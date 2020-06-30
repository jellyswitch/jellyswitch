# typed: false
# == Schema Information
#
# Table name: office_leases
#
#  id                           :bigint(8)        not null, primary key
#  always_allow_building_access :boolean          default(TRUE), not null
#  end_date                     :date             not null
#  initial_invoice_date         :date
#  start_date                   :date             not null
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  location_id                  :bigint(8)
#  office_id                    :bigint(8)        not null
#  operator_id                  :bigint(8)        not null
#  organization_id              :bigint(8)        not null
#  subscription_id              :bigint(8)
#
# Indexes
#
#  index_office_leases_on_location_id      (location_id)
#  index_office_leases_on_office_id        (office_id)
#  index_office_leases_on_operator_id      (operator_id)
#  index_office_leases_on_organization_id  (organization_id)
#  index_office_leases_on_subscription_id  (subscription_id)
#
# Foreign Keys
#
#  fk_rails_...  (location_id => locations.id)
#  fk_rails_...  (office_id => offices.id)
#  fk_rails_...  (operator_id => operators.id)
#  fk_rails_...  (organization_id => organizations.id)
#  fk_rails_...  (subscription_id => subscriptions.id)
#

require 'rails_helper'

RSpec.describe OfficeLease, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
