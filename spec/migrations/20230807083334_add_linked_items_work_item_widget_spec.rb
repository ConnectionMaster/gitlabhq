# frozen_string_literal: true

require 'spec_helper'
require_migration!

RSpec.describe AddLinkedItemsWorkItemWidget, :migration, feature_category: :portfolio_management do
  it_behaves_like 'migration that adds widget to work items definitions',
    widget_name: described_class::WIDGET_NAME,
    work_item_types: described_class::WORK_ITEM_TYPES,
    namespaced: true
end
