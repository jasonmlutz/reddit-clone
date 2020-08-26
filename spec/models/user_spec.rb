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

  it { should validate_presence_of(:username).with_message("can\'t be blank") }
  it { should validate_uniqueness_of(:username)}
  it { should validate_presence_of(:password_digest).with_message("Password can\'t be blank") }
  it { should validate_length_of(:password).is_at_least(6) }
  it {should validate_presence_of(:session_token)}
  it { should have_many(:subs) }

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

  describe '#reset_session_token!' do
    before(:all) do
      @user = User.new(username: 'jason', password: 'good_password')
      @initial_session_token = @user.session_token
      @user.reset_session_token!
    end

    after(:all) do
      @user.destroy
    end

    it "sets a session token as a string" do
      expect(@user.session_token).to be_a(String)
    end
    it "sets a session token to be a non-empty string" do
      expect(@user.session_token.length).to be > 0
    end
    it "*almost always* sets a new session token" do
      expect(@user.session_token).not_to eq(@initial_session_token)
    end
  end


end
