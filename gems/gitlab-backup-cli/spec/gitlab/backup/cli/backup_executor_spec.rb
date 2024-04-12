# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Gitlab::Backup::Cli::BackupExecutor do
  let(:context) { build_fake_context }

  subject(:executor) { described_class.new(context: context) }

  after do
    executor.release!
  end

  describe '#initialize' do
    it 'creates a workdir' do
      expect(executor.workdir).to be_a(Pathname)
      expect(executor.workdir).to be_directory
    end

    it 'initializes metadata' do
      expect(executor.metadata).to be_a(Gitlab::Backup::Cli::BackupMetadata)
    end
  end

  describe '#release!' do
    it 'removes the workdir' do
      expect { executor.release! }.to change { executor.workdir.exist? }.from(true).to(false)
    end
  end
end
