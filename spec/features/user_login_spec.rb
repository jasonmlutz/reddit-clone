require 'rails_helper'

RSpec.feature "UserLogins", type: :feature do
  scenario 'has a new session page' do
    visit new_session_url
    expect(page).to have_content 'Login'
  end

  feature 'signing in a user with valid credentials' do
    scenario 'redirects to user\'s show page'
    scenario 'shows username on show page'
    scenario 'user is displayed as logged in'
  end

  feature 'signing in a user with invalid credentials' do
    scenario 'empty username and empty password'
    scenario 'valid username and empty password'
    scenario 'valid username and incorrect password'
  end
end
