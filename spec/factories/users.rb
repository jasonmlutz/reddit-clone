# == Schema Information
#
# Table name: users
#
#  id               :bigint           not null, primary key
#  email            :string           not null
#  password_digest  :string           not null
#  session_token    :string
#  activated        :boolean          default(FALSE)
#  activation_token :string
#  admin            :boolean          default(FALSE)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
FactoryBot.define do
  factory :user do
    
  end
end
