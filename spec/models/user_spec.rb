# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  username        :string           not null
#  fname           :string           not null
#  lname           :string           not null
#  password_digest :string           not null
#  session_token   :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) do
    FactoryBot.build(:user,
      username: "jason",
      password: "good_password")
  end

  it { should validate_presence_of(:username).with_message("Username can\'t be blank") }
  it { should validate_presence_of(:password_digest).with_message("Password can\'t be blank") }
  it { should validate_length_of(:password).is_at_least(6) }

  describe '#is_password?' do
    it 'identifies a correct password' do
      expect(user.is_password?("good_password")).to be true
    end

    it 'identifies an incorrect password' do
      expect(user.is_password?("bad_password")).to be false
    end
  end

  
end
