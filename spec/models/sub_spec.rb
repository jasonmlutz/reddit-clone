# == Schema Information
#
# Table name: subs
#
#  id          :bigint           not null, primary key
#  title       :string           not null
#  description :string           not null
#  user_id     :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'rails_helper'

RSpec.describe Sub, type: :model do
  # subject(:user) do
  #   FactoryBot.build(:user,
  #     username: "jason",
  #     password: "good_password")
  # end
  subject(:sub) do
    FactoryBot.build(:sub,
    title: 'Cats',
    description: 'All about cats! They are so great!',
    user_id: 1)
  end

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:user_id) }
  it { should validate_uniqueness_of(:title) }
  it { should belong_to(:moderator) }
end
