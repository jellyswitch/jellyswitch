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

FactoryBot.define do
  factory :office_lease do
    start_date { 1.month.from_now.beginning_of_month }
    end_date { start_date + 1.year }
    operator { create(:operator, :with_lease_plans, :with_organizations) }
    location { create(:location, :with_offices, operator: operator) }
    initial_invoice_date { 1.month.from_now.beginning_of_month }

    after(:build) do |office_lease|
      operator = office_lease.operator
      office_lease.organization = operator.organizations.first
      office_lease.office = operator.offices.first
    end

    before(:create) do |office_lease|
      operator = office_lease.operator
      office_lease.organization = operator.organizations.first
      office_lease.subscription = create(
        :subscription,
        plan: operator.plans.first,
        subscribable: office_lease.organization,
        billable: office_lease.organization
      )
      office_lease.office = operator.offices.first
    end
  end
end
