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
class Sub < ApplicationRecord

  validates :title, :description, :user_id, presence: true
  validates :title, uniqueness: true

  belongs_to :moderator,
    class_name: :User,
    foreign_key: :user_id

end
