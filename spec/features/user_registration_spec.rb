require 'rails_helper'

RSpec.feature "UserRegistrations", type: :feature do
  scenario 'has a new user page' do
    visit new_user_url
    expect(page).to have_content 'Register'
  end

  feature 'registering a new user' do
    before(:each) do
      visit new_user_url
      fill_in 'username', with: 'jason'
      fill_in 'password', with: 'good_password'
      click_on 'Register'
    end

    scenario 'redirects to user\'s show page' do
      expect(page).to have_content 'Profile'
    end

    scenario 'shows username on show page after registration' do
      expect(page).to have_content 'jason'
    end

    scenario 'user persists in the database' do
      user = User.find_by(username: 'jason')
      expect(user).to_not be_nil
    end

    scenario 'user is displayed as logged in'
  end
end
