# frozen_string_literal: true

class AddSnippetRepositoriesSnippetProjectIdFk < Gitlab::Database::Migration[2.2]
  milestone '17.10'
  disable_ddl_transaction!

  def up
    add_concurrent_foreign_key :snippet_repositories, :projects, column: :snippet_project_id, on_delete: :cascade
  end

  def down
    with_lock_retries do
      remove_foreign_key :snippet_repositories, column: :snippet_project_id
    end
  end
end
