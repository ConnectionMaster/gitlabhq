# frozen_string_literal: true

class AddBulkImportFailuresNamespaceIdTrigger < Gitlab::Database::Migration[2.2]
  milestone '17.9'

  def up
    install_sharding_key_assignment_trigger(
      table: :bulk_import_failures,
      sharding_key: :namespace_id,
      parent_table: :bulk_import_entities,
      parent_sharding_key: :namespace_id,
      foreign_key: :bulk_import_entity_id
    )
  end

  def down
    remove_sharding_key_assignment_trigger(
      table: :bulk_import_failures,
      sharding_key: :namespace_id,
      parent_table: :bulk_import_entities,
      parent_sharding_key: :namespace_id,
      foreign_key: :bulk_import_entity_id
    )
  end
end
