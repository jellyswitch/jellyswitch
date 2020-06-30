# typed: false
# == Schema Information
#
# Table name: organizations
#
#  id                 :bigint(8)        not null, primary key
#  name               :string           not null
#  out_of_band        :boolean          default(TRUE), not null
#  slug               :string
#  website            :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  operator_id        :integer          default(1), not null
#  owner_id           :integer
#  stripe_customer_id :string
#
# Indexes
#
#  index_organizations_on_operator_id  (operator_id)
#

class Organization < ApplicationRecord
  searchkick
  # Slugs
  extend FriendlyId
  friendly_id :name, use: :slugged

  # Relationships
  has_many :users
  has_many :office_leases
  has_many :invoices, as: :billable
  belongs_to :owner, class_name: "User", optional: true
  belongs_to :operator
  acts_as_tenant :operator

  has_many :subscriptions, as: :subscribable

  delegate :email, to: :owner

  scope :eligible_for_lease, -> { where.not(stripe_customer_id: nil).or(where(out_of_band: true)) }

  def search_data
    {
      name: name,
      owner: owner.name,
      stripe_customer_id: stripe_customer_id,
    }
  end

  # Form and view helpers
  def self.options_for_select
    Organization.all.map do |org|
      [org.name, org.id]
    end.prepend(["", nil])
  end

  def has_active_lease?
    active_leases.length > 0
  end

  def active_leases
    office_leases.active
  end

  def stripe_customer
    return unless stripe_customer_id
    operator.retrieve_stripe_customer(self)
  end

  def find_or_create_stripe_customer
    stripe_customer || operator.create_stripe_customer(self)
  end

  def has_billing?
    has_stripe_customer? && card_added?
  end

  def card_added
    stripe_customer.sources["data"].count > 0
  end

  def card_added?
    card_added
  end

  def has_stripe_customer?
    stripe_customer_id.present?
  end

  def card_last_4_digits
    if stripe_customer && stripe_customer.sources && stripe_customer.sources.data
      if stripe_customer.sources.data.count < 1
        nil
      else
        cards = stripe_customer.sources.data.select { |source| source.object == "card" }
        if cards.first
          if cards.first.respond_to? :last4
            cards.first.last4
          else
            nil
          end
        else
          nil
        end
      end
    else
      nil
    end
  end

  def payment_method
    if has_billing?
      "Credit card on file"
    else
      if out_of_band?
        "Via cash or check"
      else
        "None"
      end
    end
  end
end
