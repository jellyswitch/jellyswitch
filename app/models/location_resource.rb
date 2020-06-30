# typed: strong
# == Schema Information
#
# Table name: location_resources
#
#  id            :bigint(8)        not null, primary key
#  resource_type :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  location_id   :bigint(8)
#  resource_id   :bigint(8)
#
# Indexes
#
#  index_location_resources_on_location_id                    (location_id)
#  index_location_resources_on_resource_type_and_resource_id  (resource_type,resource_id)
#
# Foreign Keys
#
#  fk_rails_...  (location_id => locations.id)
#

class LocationResource < ApplicationRecord
  belongs_to :location
  belongs_to :resource, polymorphic: true
end
