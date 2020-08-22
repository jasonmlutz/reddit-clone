require 'rails_helper'

RSpec.feature "UserLogins", type: :feature do
  scenario 'has a new session page' do
    visit new_session_url
    expect(page).to have_content 'Log in!'
  end

  feature 'signing in a user with valid credentials' do
    before(:each) do
      @user = User.create(username: 'jason', password: 'good_password')
      visit new_session_url
      fill_in 'username', with: 'jason'
      fill_in 'password', with: 'good_password'
      click_on 'Log in'
    end

    scenario 'redirects to user\'s show page' do
      expect(page).to have_content 'Profile'
    end
    scenario 'shows username on show page' do
      expect(page).to have_content 'jason'
    end
    scenario 'user is displayed as logged in'
  end

  feature 'signing in a user with invalid credentials' do
    scenario 'empty username and empty password'
    scenario 'valid username and empty password'
    scenario 'valid username and incorrect password'
  end
end
