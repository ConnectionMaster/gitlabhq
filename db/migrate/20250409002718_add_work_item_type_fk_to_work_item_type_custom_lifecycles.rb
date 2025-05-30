# frozen_string_literal: true

class AddWorkItemTypeFkToWorkItemTypeCustomLifecycles < Gitlab::Database::Migration[2.2]
  disable_ddl_transaction!
  milestone '17.11'

  def up
    add_concurrent_foreign_key :work_item_type_custom_lifecycles, :work_item_types,
      column: :work_item_type_id, on_delete: :cascade
  end

  def down
    remove_foreign_key_if_exists :work_item_type_custom_lifecycles, column: :work_item_type_id
  end
end
