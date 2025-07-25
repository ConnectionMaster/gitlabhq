# frozen_string_literal: true

class QueueBackfillPushEventPayloadsProjectId < Gitlab::Database::Migration[2.2]
  milestone '17.10'
  restrict_gitlab_migration gitlab_schema: :gitlab_main_cell

  MIGRATION = "BackfillPushEventPayloadsProjectId"
  DELAY_INTERVAL = 2.minutes
  BATCH_SIZE = 1000
  SUB_BATCH_SIZE = 100

  def up
    # no-op because the original migration failed (https://gitlab.com/gitlab-org/gitlab/-/merge_requests/183123#note_2425371444)
  end

  def down
    # no-op because the original migration failed (https://gitlab.com/gitlab-org/gitlab/-/merge_requests/183123#note_2425371444)
  end
end
