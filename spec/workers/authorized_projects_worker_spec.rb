# frozen_string_literal: true

require 'spec_helper'

RSpec.describe AuthorizedProjectsWorker, feature_category: :permissions do
  it_behaves_like "refreshes user's project authorizations"
end
