# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Dashboard shortcuts', :js, feature_category: :shared do
  context 'logged in' do
    let(:user) { create(:user) }
    let(:project) { create(:project) }

    before do
      project.add_developer(user)
      sign_in(user)
      visit root_dashboard_path
    end

    it 'navigate to tabs' do
      find('body').send_keys([:shift, 'I'])

      check_page_title('Issues')

      find('body').send_keys([:shift, 'M'])

      check_page_title('Merge requests')

      find('body').send_keys([:shift, 'R'])

      check_page_title('Merge requests')

      find('body').send_keys([:shift, 'T'])

      expect(page).to have_selector('.js-todos-all')

      find('body').send_keys([:shift, 'G'])

      expect(page).to have_selector('[data-testid="groups-page"]')

      find('body').send_keys([:shift, 'P'])

      check_page_title('Projects')

      find('body').send_keys([:shift, 'A'])

      check_page_title('Activity')

      find('body').send_keys([:shift, 'L'])

      check_page_title('Milestones')
    end
  end

  context 'logged out' do
    before do
      visit explore_root_path
    end

    it 'navigate to tabs' do
      find('body').send_keys([:shift, 'G'])

      expect(page).to have_content('No public or internal groups')

      find('body').send_keys([:shift, 'S'])

      expect(page).to have_content('There are no snippets found')

      find('body').send_keys([:shift, 'P'])

      find('.nothing-here-block')
      expect(page).to have_content('Explore public groups to find projects to contribute to')
    end
  end

  def check_page_title(title)
    expect(find_by_testid('page-heading')).to have_content(title)
  end
end
