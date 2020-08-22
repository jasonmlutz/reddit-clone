require 'rails_helper'

RSpec.feature "UserNavigations", type: :feature do
  feature 'new session -> new user' do
    before(:each) do
      visit new_session_url
    end

    scenario 'displays message for new users' do
      expect(page).to have_content 'New user?'
    end

    scenario 'has registration button' do
      expect(page).to have_selector(:link_or_button, 'Register')
    end

    scenario 'registration button renders new user template' do
      click_on 'Register'
      expect(page).to have_current_path "/users/new"
    end
  end

  feature 'new user -> new session' do
    before(:each) do
      visit new_user_url
    end

    scenario 'displays message for returning users' do
      expect(page).to have_content 'Already registered?'
    end

    scenario 'has log in button' do
      expect(page).to have_selector(:link_or_button, 'Log in')
    end

    scenario 'log in button renders new session template' do
      click_on 'Log in'
      expect(page).to have_current_path "/session/new"
    end
  end
end
