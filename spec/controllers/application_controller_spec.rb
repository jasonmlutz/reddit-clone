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
end
