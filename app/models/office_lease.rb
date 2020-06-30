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

class OfficeLease < ApplicationRecord
  belongs_to :operator
  belongs_to :organization
  belongs_to :office
  belongs_to :subscription, dependent: :destroy
  belongs_to :location

  acts_as_scopable :operator, :location

  has_one_attached :lease_agreement

  accepts_nested_attributes_for :subscription

  scope :active, -> { where('now() BETWEEN start_date AND end_date') }
  scope :inactive, -> { where.not('now() BETWEEN start_date AND end_date') }

  def has_lease?
    lease_agreement.attached?
  end

  def active?
      Time.current.between?(start_date, end_date)
  end

  def subscription_active?
    subscription.active?
  end

  def group_name
    organization.name
  end

  def office_name
    office.name
  end

  def set_end_date!
    subscription.set_end_date!(end_date.to_time)
  end
end
