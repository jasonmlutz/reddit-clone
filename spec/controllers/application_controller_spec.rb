require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  describe '#login!' do
    before(:each) do
      User.create(username: 'jason', password: 'good_password')
      @user = User.find_by(username: 'jason')
      subject.login!(@user)
    end

    it 'returns the logged-in user as the current_user' do
      expect(subject.current_user).to eq(@user)
    end
  end

  describe '#logout!' do
    before(:each) do
      User.create(username: 'jason', password: 'good_password')
      @user = User.find_by(username: 'jason')
      subject.login!(@user)
      @initial_session_token = @user.session_token
      subject.logout!
    end

    after(:each) do
      @user.destroy
    end
    it "sets session[:session_token] to nil" do
      expect(session[:session_token]).to be_nil
    end

    it "sets current_user to nil" do
      expect(subject.current_user).to be_nil
    end

    it "resets the session_token of the logged-out user" do
      expect(@user.session_token).to_not eq(@initial_session_token)
    end
  end
end
