# typed: false
# == Schema Information
#
# Table name: operators
#
#  id                            :bigint(8)        not null, primary key
#  android_server_key            :string
#  android_url                   :string
#  announcements_enabled         :boolean          default(TRUE), not null
#  approval_required             :boolean          default(TRUE), not null
#  billing_state                 :string           default("demo"), not null
#  building_address              :string           default("not set"), not null
#  bulletin_board_enabled        :boolean          default(FALSE), not null
#  checkin_notifications         :boolean          default(TRUE), not null
#  checkin_required              :boolean          default(FALSE), not null
#  childcare_enabled             :boolean          default(FALSE), not null
#  contact_email                 :string
#  contact_name                  :string
#  contact_phone                 :string
#  credits_enabled               :boolean          default(FALSE), not null
#  day_pass_cost_in_cents        :integer          default(2500), not null
#  day_pass_notifications        :boolean          default(TRUE), not null
#  door_integration_enabled      :boolean          default(TRUE), not null
#  email_enabled                 :boolean          default(FALSE), not null
#  events_enabled                :boolean          default(TRUE), not null
#  ios_url                       :string
#  kisi_api_key                  :string
#  member_feedback_notifications :boolean          default(TRUE), not null
#  membership_notifications      :boolean          default(TRUE), not null
#  membership_text               :string
#  name                          :string           not null
#  offices_enabled               :boolean          default(TRUE), not null
#  post_notifications            :boolean          default(TRUE), not null
#  refund_notifications          :boolean          default(TRUE), not null
#  reservation_notifications     :boolean          default(FALSE), not null
#  rooms_enabled                 :boolean          default(TRUE), not null
#  signup_notifications          :boolean          default(FALSE), not null
#  skip_onboarding               :boolean          default(FALSE), not null
#  snippet                       :string           default("Generic snippet about the space"), not null
#  square_footage                :integer          default(0), not null
#  stripe_access_token           :string
#  stripe_publishable_key        :string
#  stripe_refresh_token          :string
#  subdomain                     :string           not null
#  wifi_name                     :string           default("not set"), not null
#  wifi_password                 :string           default("not set"), not null
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  stripe_user_id                :string
#
# Indexes
#
#  index_operators_on_subdomain  (subdomain) UNIQUE
#

class Operator < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged, slug_column: :subdomain

  has_many :announcements
  has_many :day_passes
  has_many :day_pass_types
  has_many :doors
  has_many :door_punches
  has_many :feed_items
  has_many :invoices
  has_many :leads
  has_many :member_feedbacks
  has_many :operator_surveys
  has_many :organizations
  has_many :plans
  has_many :rooms
  has_many :users
  has_many :offices
  has_many :office_leases
  has_many :locations
  has_many :weekly_updates

  has_many :childcare_reservations, through: :locations
  has_many :child_profiles, through: :users
  has_many :events, through: :locations
  has_many :posts, through: :locations
  has_many :subscriptions, through: :plans

  has_one_attached :background_image
  has_one_attached :logo_image
  has_one_attached :terms_of_service
  has_one_attached :push_notification_certificate

  delegate :create_stripe_customer,
           :retrieve_stripe_customer,
           :create_stripe_invoice_item,
           :create_stripe_invoice,
           :retrieve_stripe_invoice,
           :create_stripe_refund,
           :retrieve_stripe_refund,
           :create_stripe_subscription,
           :retrieve_stripe_plans,
           :create_stripe_plan,
           :mark_invoice_paid,
           :create_or_update_customer_payment,
           :charge_invoice,
           :retrieve_stripe_customers,
           :list_stripe_subscriptions,
           :stripe_request,
           to: :stripe_operator

  scope :production, -> { where(billing_state: "production") }
  scope :demo, -> { where(billing_state: "demo") }

  %w(rooms offices office_leases member_feedbacks feed_items doors).each do |resource|
    define_method "#{resource}_by_location" do |location|
      public_send(resource).where(location: location)
    end
  end

  def has_mobile_app_links?
    ios_url.present? && android_url.present?
  end

  def has_contact_info?
    contact_name.present? && contact_email.present? && contact_phone.present?
  end

  def email_enabled?
    email_enabled || Rails.env.development?
  end

  def demo?
    billing_state == "demo"
  end

  def production?
    billing_state == "production" || subdomain == "southlakecoworking"
  end

  def stripe_secret_key
    if production? && subdomain != "southlakecoworking"
      Rails.configuration.stripe[:secret_key]
    else
      Rails.configuration.stripe[:test_secret_key]
    end
  end

  def stripe_operator
    @stripe_operator ||= StripeOperator.new(self)
  end

  def reset_stripe_to_demo!
    update(
      stripe_user_id: ENV["STRIPE_ACCOUNT_ID"],
      stripe_publishable_key: nil,
      stripe_refresh_token: nil,
      stripe_access_token: nil,
      billing_state: "demo",
    )
  end

  def checkins
    Checkin.for_operator(self)
  end

  # Predicates for features

  def day_passes_enabled?
    day_pass_types.count > 0
  end

  def memberships_enabled?
    plans.individual.visible.available.count > 0
  end

  def onboarded?
    plans.count > 0 &&
    day_pass_types.count > 0 &&
    ((rooms_enabled? && rooms.count > 0) || true ) &&
    (((door_integration_enabled? && doors.count > 0) || true) || locations.all? {|l| l.building_access_instructions.present? }) &&
    users.members.count > 0
  end

  def has_active_office_leases?
    office_leases.active.count > 0
  end

  private

  class StripeOperator < SimpleDelegator
    include StripeUtils
  end

  private_constant :StripeOperator
end
