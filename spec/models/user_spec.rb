# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  username        :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
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
  it { should validate_uniqueness_of(:username)}
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

  describe 'User::find_by_credentials' do
    before(:all) do
      @new_user = User.new(username: 'jason', password: 'good_password')
      @new_user.save!
    end
    after(:all) do
      @new_user.destroy
    end

    context "with invalid credentials" do
      it "returns nil with correct username + incorrect password" do
        expect(User.find_by_credentials('jason', 'bad_password')).to be_nil
      end
      it "returns nil with incorrect username + correct password" do
        expect(User.find_by_credentials('jarmo', 'good_password')).to be_nil
      end
      it "returns nil with incorrect username + password" do
        expect(User.find_by_credentials('jarmo', 'bad_password')).to be_nil
      end
    end

    context "with valid credentials" do
      it "returns correct user record" do
        expect(User.find_by_credentials('jason', 'good_password')).to eq(@new_user)
      end
    end
  end


end
