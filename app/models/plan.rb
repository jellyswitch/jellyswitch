# typed: false
# == Schema Information
#
# Table name: plans
#
#  id                           :bigint(8)        not null, primary key
#  always_allow_building_access :boolean          default(TRUE), not null
#  amount_in_cents              :integer          not null
#  available                    :boolean          default(TRUE), not null
#  childcare_reservations       :integer          default(0), not null
#  commitment_interval          :integer
#  credits                      :integer          default(0), not null
#  day_limit                    :integer          default(0), not null
#  has_day_limit                :boolean          default(FALSE), not null
#  interval                     :string           not null
#  name                         :string           not null
#  plan_type                    :string
#  slug                         :string
#  visible                      :boolean          default(TRUE), not null
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  operator_id                  :integer          default(1), not null
#  stripe_plan_id               :string
#
# Indexes
#
#  index_plans_on_operator_id  (operator_id)
#

class Plan < ApplicationRecord
  include ActionView::Helpers::NumberHelper
  acts_as_tenant :operator

  has_rich_text :description

  # Relationships
  has_many :subscriptions
  belongs_to :operator
  has_and_belongs_to_many :locations

  # Slugs
  extend FriendlyId
  friendly_id :name, use: :slugged

  # Scopes
  scope :available, -> { where(available: true) }
  scope :unavailable, ->{ where(available: false) }
  scope :visible, -> { where(visible: true) }
  scope :invisible, -> { where(visible: false) }
  scope :individual, -> { where(plan_type: 'individual') }
  scope :for_individuals, -> { individual.available.visible }
  scope :for_location, ->(location) do
    joins(:locations).where(locations: {id: location.id})
  end
  scope :lease, -> { where(plan_type: 'lease') }
  scope :nonzero, -> { where('amount_in_cents > 0') }
  scope :free, -> { where('amount_in_cents <= 0') }
  scope :cheapest, -> { order('amount_in_cents ASC').first }

  PLAN_TYPES = %w(individual lease).freeze

  def stripe_plan
    Stripe::Plan.retrieve(self.stripe_plan_id, {
      api_key: operator.stripe_secret_key,
      stripe_account: operator.stripe_user_id
  })
  end

  def plan_name
    "#{operator.name} #{name}"
  end

  def display_interval
    {
      "daily" => "day",
      "weekly" => "week",
      "monthly" => "month",
      "quarterly" => "quarter",
      "biannually" => "6-months",
      "annually" => "year"
    }[interval]
  end

  def stripe_interval
    {
      "daily" => "day",
      "weekly" => "week",
      "monthly" => "month",
      "quarterly" => "month",
      "biannually" => "month",
      "annually" => "year"
    }[interval]
  end

  def stripe_interval_count
    if quarterly?
      3
    elsif biannually?
      6
    else
      1
    end
  end

  def short_interval
    {
      "daily" => "day",
      "weekly" => "wk",
      "monthly" => "mo",
      "quarterly" => "qt",
      "biannually" => "2x-yr",
      "annually" => "yr"
    }[interval]
  end

  def plan_slug
    "#{operator.name.parameterize}-#{slug}"
  end

  # Enumeration options
  INTERVAL_OPTIONS = [
    "daily",
    "monthly",
    "quarterly",
    "biannually",
    "annually"
  ]

  LEASE_INTERVAL_OPTIONS = [
    "monthly",
    "annually"
  ]

  # Class methods
  def self.options_for_interval
    INTERVAL_OPTIONS
  end

  def self.lease_options_for_interval
    LEASE_INTERVAL_OPTIONS
  end

  # Instance methods
  def pretty_name
    "#{name} (#{pretty_price})"
  end

  def pretty_amount
    number_to_currency(amount_in_cents / 100.0)
  end

  def pretty_price
    "#{pretty_amount} / #{short_interval}"
  end

  def lease?
    plan_type == "lease"
  end

  def individual?
    plan_type == "individual"
  end

  def annual?
    interval == "annually"
  end

  def quarterly?
    interval == "quarterly"
  end
  
  def biannually?
    interval == "biannually"
  end

  def has_commitment_interval?
    commitment_interval.present?
  end

  def commitment_duration
    {
      "weekly" => commitment_interval.weeks,
      "monthly" => commitment_interval.months,
      "quarterly" => commitment_interval.months * 3,
      "biannually" => commitment_interval.months * 3 * 2,
      "annually" => commitment_interval.years,
    }[interval]
  end
end
