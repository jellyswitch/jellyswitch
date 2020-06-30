# == Schema Information
#
# Table name: child_profiles
#
#  id         :bigint(8)        not null, primary key
#  birthday   :datetime
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#

class ChildProfile < ApplicationRecord
  belongs_to :user
  has_many :childcare_reservations

  has_rich_text :notes

  has_one_attached :photo

  def thumbnail
    photo.variant(resize: "180x180", auto_orient: true)
  end
end
