# frozen_string_literal: true

module Gitlab
  module Tracking
    class StandardContext
      GITLAB_STANDARD_SCHEMA_URL = 'iglu:com.gitlab/gitlab_standard/jsonschema/1-1-5'
      GITLAB_RAILS_SOURCE = 'gitlab-rails'

      def initialize(
        namespace_id: nil, plan_name: nil, project_id: nil, user: nil,
        feature_enabled_by_namespace_ids: nil, **extra)
        check_argument_type(:namespace_id, namespace_id, [Integer])
        check_argument_type(:plan_name, plan_name, [String])
        check_argument_type(:project_id, project_id, [Integer])
        check_argument_type(:user, user, [User, DeployToken])

        @namespace_id = namespace_id
        @plan_name = plan_name
        @project_id = project_id
        @user = user
        @extra = extra
        @feature_enabled_by_namespace_ids = feature_enabled_by_namespace_ids
      end

      def to_context
        SnowplowTracker::SelfDescribingJson.new(GITLAB_STANDARD_SCHEMA_URL, to_h)
      end

      def environment
        return 'staging' if Gitlab.staging?

        return 'production' if Gitlab.com?

        return 'org' if Gitlab.org?

        return 'self-managed' if Rails.env.production?

        'development'
      end

      def source
        GITLAB_RAILS_SOURCE
      end

      private

      attr_accessor :namespace_id, :project_id, :extra, :plan_name, :user, :feature_enabled_by_namespace_ids

      def to_h
        {
          environment: environment,
          source: source,
          correlation_id: Labkit::Correlation::CorrelationId.current_or_new_id,
          plan: plan_name,
          extra: extra,
          user_id: tracked_user_id,
          global_user_id: global_user_id,
          is_gitlab_team_member: gitlab_team_member?(user&.id),
          namespace_id: namespace_id,
          project_id: project_id,
          feature_enabled_by_namespace_ids: feature_enabled_by_namespace_ids,
          realm: realm,
          instance_id: instance_id,
          unique_instance_id: Gitlab::GlobalAnonymousId.instance_uuid,
          host_name: Gitlab.config.gitlab.host,
          instance_version: Gitlab.version_info.to_s,
          context_generated_at: Time.current
        }
      end

      def tracked_user_id
        return unless user.is_a? User

        Gitlab::CryptoHelper.sha256(user.id)
      end

      def check_argument_type(argument_name, argument_value, allowed_classes)
        return if argument_value.nil? || allowed_classes.any? { |allowed_class| argument_value.is_a?(allowed_class) }

        exception = "Invalid argument type passed for #{argument_name}. " \
          "Should be one of #{allowed_classes.map(&:to_s)}"
        Gitlab::ErrorTracking.track_and_raise_for_dev_exception(ArgumentError.new(exception))
      end

      def global_user_id
        return unless user.is_a? User

        Gitlab::GlobalAnonymousId.user_id(user)
      end

      # Overridden in EE
      def gitlab_team_member?(_user_id)
        nil
      end

      def realm
        nil
      end

      def instance_id
        nil
      end
    end
  end
end

Gitlab::Tracking::StandardContext.prepend_mod
