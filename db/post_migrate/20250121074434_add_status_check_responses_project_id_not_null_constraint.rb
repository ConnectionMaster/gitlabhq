# frozen_string_literal: true

class AddStatusCheckResponsesProjectIdNotNullConstraint < Gitlab::Database::Migration[2.2]
  disable_ddl_transaction!
  milestone '17.9'

  def up
    add_not_null_constraint :status_check_responses, :project_id, validate: false
  end

  def down
    remove_not_null_constraint :status_check_responses, :project_id
  end
end
