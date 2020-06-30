# == Schema Information
#
# Table name: events
#
#  id              :bigint(8)        not null, primary key
#  description     :text
#  ends_at         :datetime
#  location_string :string
#  starts_at       :datetime         not null
#  title           :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  location_id     :integer          not null
#  user_id         :integer          not null
#

class Event < ApplicationRecord
  belongs_to :location
  belongs_to :user

  has_many :rsvps

  has_one_attached :image
  
  scope :future, -> () { where("starts_at >= ?", Time.current) }
  scope :past, -> () { where("starts_at < ?", Time.current) }
  scope :today, -> () { where(starts_at: Time.current.beginning_of_day..Time.current.end_of_day) }

  def thumbnail
    image.variant(resize: "180x180", auto_orient: true)
  end

  def social_image
    image.variant(resize: "500x500", auto_orient: true)
  end
end
