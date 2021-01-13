require 'rails_helper'

RSpec.feature "UserLogins", type: :feature do
  scenario 'logout button is not present' do
    visit new_session_url
    expect(page).to_not have_selector(:link_or_button, 'Logout')
  end

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
    scenario 'user is displayed as logged in' do
      visit subs_url
      expect(page).to have_content 'Current user: jason'
    end
  end

  shared_examples "renders new session with errors and 401 status" do
    before(:each) do
      @user = User.create(username: 'jason', password: 'good_password')
      visit new_session_url
      fill_in 'username', with: params[:username]
      fill_in 'password', with: params[:password]
      click_on 'Log in'
    end

    it "renders the new session template" do
      expect(page).to have_content 'Log in'
    end

    it "displays flash alert" do
      expect(page).to have_content 'alert:'
    end

    it "has 401 status" do
      expect(page).to have_http_status(401)
    end

  end

  feature 'signing in a user with invalid credentials' do
    feature 'empty username and empty password' do
      let(:params) {{ username: "", password: "" }}
      it_behaves_like "renders new session with errors and 401 status"
    end
    feature 'valid username and empty password' do
      let(:params) {{ username: "jason", password: "" }}
      it_behaves_like "renders new session with errors and 401 status"
    end
    feature 'valid username and incorrect password' do
      let(:params) {{ username: "jason", password: "bad_password" }}
      it_behaves_like "renders new session with errors and 401 status"
    end
  end
end
