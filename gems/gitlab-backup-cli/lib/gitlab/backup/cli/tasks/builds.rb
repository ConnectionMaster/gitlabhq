# frozen_string_literal: true

module Gitlab
  module Backup
    module Cli
      module Tasks
        class Builds < Task
          def self.id = 'builds'

          def human_name = _('builds')

          def destination_path = 'builds.tar.gz'

          private

          def target
            ::Backup::Targets::Files.new(nil, storage_path, options: options)
          end

          def storage_path = context.ci_builds_path
        end
      end
    end
  end
end
