# typed: false
# == Schema Information
#
# Table name: subscriptions
#
#  id                     :bigint(8)        not null, primary key
#  active                 :boolean          default(TRUE), not null
#  billable_type          :string
#  pending                :boolean          default(FALSE), not null
#  start_date             :date             not null
#  subscribable_type      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  billable_id            :bigint(8)
#  plan_id                :integer          not null
#  stripe_subscription_id :string
#  subscribable_id        :bigint(8)
#
# Indexes
#
#  index_subscriptions_on_billable_type_and_billable_id          (billable_type,billable_id)
#  index_subscriptions_on_subscribable_type_and_subscribable_id  (subscribable_type,subscribable_id)
#

class Subscription < ApplicationRecord
  # Callbacks
  before_destroy :check_for_stripe_subscription

  # Relationships
  belongs_to :plan
  belongs_to :billable, polymorphic: true
  belongs_to :subscribable, polymorphic: true
  has_many :office_leases

  # Scopes
  scope :active, -> { where(active: true) }
  scope :pending, -> { where(pending: true) }
  scope :for_operator, ->(operator) { joins(:plan).where("plans.operator_id = '?'", operator.id) }
  scope :for_location, ->(location) do
    joins(:plan).where(plans: {id: Plan.for_location(location).map(&:id) })
  end 
  scope :for_week, -> (week_start, week_end) { where('created_at > ? and created_at <= ?', week_start, week_end) }

  accepts_nested_attributes_for :plan

  delegate :operator, to: :subscribable

  # Instance methods
  def cancel_stripe!
    stripe_subscription.delete
  end

  def has_stripe_subscription?
    stripe_subscription_id.present? && stripe_subscription.id.present?
  rescue StandardError => e
    false
  end

  def stripe_subscription
    if pending?
      nil
    else
      Stripe::Subscription.retrieve(self.stripe_subscription_id, {
        api_key: plan.operator.stripe_secret_key,
        stripe_account: plan.operator.stripe_user_id
      })
    end
  end

  def pretty_datetime
    updated_at.strftime("%m/%d/%Y at %l:%M%P")
  end

  def check_for_stripe_subscription
    if stripe_subscription_id.present?
      raise "Cancel Stripe Subscription first: #{stripe_subscription_id}"
    end
  end

  def pretty_name
    if plan.present?
      plan.pretty_name
    else
      "error"
    end
  end

  def has_days_left?
    if plan.has_day_limit?
      days_left > 0
    else
      true
    end
  end

  def days_left
    report = Jellyswitch::UsageReport.new(subscribable)
    plan.day_limit - report.days_used_count
  end

  def has_end_date?
    has_stripe_subscription? && stripe_subscription.cancel_at.present?
  end

  def end_date
    Time.at(stripe_subscription.cancel_at)
  end

  def set_end_date!(date)
    s = stripe_subscription
    s.cancel_at = date.to_i
    s.save
  end

  def has_canceled_at?
    has_stripe_subscription? && stripe_subscription.canceled_at.present?
  end

  def canceled_at
    Time.at(stripe_subscription.canceled_at)
  end
end
