# frozen_string_literal: true

module Resolvers
  class UserDiscussionsCountResolver < BaseResolver
    include Gitlab::Graphql::Authorize::AuthorizeResource

    type GraphQL::Types::Int, null: true

    def resolve
      authorize!(object)

      load_discussions_counts
    end

    def authorized_resource?(object)
      ability = "read_#{object.class.name.underscore}".to_sym
      context[:current_user].present? && Ability.allowed?(context[:current_user], ability, object)
    end

    private

    def load_discussions_counts
      BatchLoader::GraphQL.for(object.id).batch do |ids, loader, args|
        counts = Note.count_for_collection(
          ids, object.class.base_class.name, 'COUNT(DISTINCT discussion_id) as count'
        ).index_by(&:noteable_id)

        ids.each do |id|
          loader.call(id, counts[id]&.count || 0)
        end
      end
    end
  end
end

::Resolvers::UserDiscussionsCountResolver.prepend_mod
