# typed: false
# == Schema Information
#
# Table name: day_passes
#
#  id               :bigint(8)        not null, primary key
#  billable_type    :string
#  day              :date             not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  billable_id      :bigint(8)
#  day_pass_type_id :integer
#  invoice_id       :integer
#  operator_id      :integer          default(1), not null
#  stripe_charge_id :string
#  user_id          :integer          not null
#
# Indexes
#
#  index_day_passes_on_billable_type_and_billable_id  (billable_type,billable_id)
#  index_day_passes_on_operator_id                    (operator_id)
#

class DayPass < ApplicationRecord
  # Relationships
  belongs_to :billable, polymorphic: true
  belongs_to :day_pass_type
  belongs_to :invoice, optional: true
  belongs_to :user
  belongs_to :operator
  acts_as_tenant :operator

  # Scopes
  scope :today, -> { where(day: Time.current) }
  scope :for_day, -> (date) { where(day: date) }
  scope :last_30_days, -> { where('day > ?', 30.days.ago ) }
  scope :this_month, -> () { where("day > ?", Time.current.beginning_of_month) }
  scope :for_week, -> (week_start, week_end) { where('day > ? and day <= ?', week_start, week_end) }

  # Instance methods
  def pretty_day
    day.strftime("%m/%d/%Y")
  end

  def charge_description
    "#{operator.name} Day Pass for #{pretty_day}"
  end

  def today?
    day.day == Time.current.day
  end

  def day_pass_type_name
    if day_pass_type.present?
      day_pass_type.name
    else
      "Unknown"
    end
  end
end
