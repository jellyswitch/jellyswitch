# typed: false
# == Schema Information
#
# Table name: doors
#
#  id          :bigint(8)        not null, primary key
#  available   :boolean          default(TRUE), not null
#  name        :string           not null
#  slug        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  kisi_id     :integer
#  location_id :bigint(8)
#  operator_id :integer          default(1), not null
#
# Indexes
#
#  index_doors_on_location_id  (location_id)
#  index_doors_on_operator_id  (operator_id)
#
# Foreign Keys
#
#  fk_rails_...  (location_id => locations.id)
#

class Door < ApplicationRecord
  searchkick
  # Slugs
  extend FriendlyId
  friendly_id :name, use: :slugged

  # Relationships
  has_many :door_punches
  belongs_to :operator
  acts_as_scopable :operator, :location

  def search_data
    {
      name: name
    }
  end
end
