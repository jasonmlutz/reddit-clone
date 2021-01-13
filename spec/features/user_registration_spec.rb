require 'rails_helper'

RSpec.feature "UserRegistrations", type: :feature do
  scenario 'has a new user page' do
    visit new_user_url
    expect(page).to have_content 'Register'
  end

  feature 'registering a new user with valid inputs' do
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

    scenario 'user is displayed as logged in' do
      visit subs_url
      expect(page).to have_content 'Current user: jason'
    end
  end

  shared_examples "renders new with 422 status" do
    before(:all) do
      @user = User.create(username: 'jason', password: 'good_password')
    end
    before(:each) do
      visit new_user_url
      fill_in 'username', with: params[:username]
      fill_in 'password', with: params[:password]
      click_on 'Register'
    end
    after(:all) do
      @user.destroy
    end

    it "renders the new user template" do
      expect(page).to have_content 'Register'
    end

    it "has 422 status" do
      expect(page).to have_http_status(422)
    end
  end

  shared_examples "has `username unavailable` error message" do
    it 'displays correct error' do
      @user = User.create(username: 'jason', password: 'good_password')
      visit new_user_url
      fill_in 'username', with: params[:username]
      fill_in 'password', with: params[:password]
      click_on 'Register'
      expect(page).to have_content "already been taken"
    end
  end

  shared_examples "has `username presence` error message" do
    it 'displays correct error' do
      @user = User.create(username: 'jason', password: 'good_password')
      visit new_user_url
      fill_in 'username', with: params[:username]
      fill_in 'password', with: params[:password]
      click_on 'Register'
      expect(page).to have_content "can't be blank"
    end
  end

  shared_examples "has password too short error message" do
    it 'displays correct error' do
      @user = User.create(username: 'jason', password: 'good_password')
      visit new_user_url
      fill_in 'username', with: params[:username]
      fill_in 'password', with: params[:password]
      click_on 'Register'
      expect(page).to have_content "too short"
    end
  end

  feature 'registering a user with invalid inputs' do

    feature 'empty username and empty password' do
      let(:params) {{ username: "", password: ""}}
      it_behaves_like "renders new with 422 status"
      it_behaves_like "has `username presence` error message"
      it_behaves_like "has password too short error message"
    end

    feature 'empty username and invalid (short) password' do
      let(:params) {{ username: "", password: "abcd"}}
      it_behaves_like "renders new with 422 status"
      it_behaves_like "has `username presence` error message"
      it_behaves_like "has password too short error message"

    end

    feature 'empty username and valid password' do
      let(:params) {{ username: "", password: "long_password"}}
      it_behaves_like "renders new with 422 status"
      it_behaves_like "has `username presence` error message"
    end

    feature 'duplicate username and empty password' do
      let(:params) {{ username: "jason", password: ""}}
      it_behaves_like "renders new with 422 status"
      it_behaves_like "has `username unavailable` error message"
      it_behaves_like "has password too short error message"
    end

    feature 'duplicate username and invalid (short) password' do
      let(:params) {{ username: "jason", password: "abcd"}}
      it_behaves_like "renders new with 422 status"
      it_behaves_like "has `username unavailable` error message"
      it_behaves_like "has password too short error message"
    end

    feature 'duplicate username and valid password' do
      let(:params) {{ username: "jason", password: "long_password"}}
      it_behaves_like "renders new with 422 status"
      it_behaves_like "has `username unavailable` error message"
    end

    feature 'valid username and empty password' do
      let(:params) {{ username: "new_user", password: ""}}
      it_behaves_like "renders new with 422 status"
      it_behaves_like "has password too short error message"
    end

    feature 'valid username and invalid (short) password' do
      let(:params) {{ username: "new_user", password: "abcd"}}
      it_behaves_like "renders new with 422 status"
      it_behaves_like "has password too short error message"
    end
  end
end
