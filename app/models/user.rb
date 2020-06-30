# typed: false
# == Schema Information
#
# Table name: users
#
#  id                            :bigint(8)        not null, primary key
#  admin                         :boolean          default(FALSE), not null
#  always_allow_building_access  :boolean          default(FALSE), not null
#  android_token                 :string
#  approved                      :boolean          default(FALSE), not null
#  archived                      :boolean          default(FALSE), not null
#  bill_to_organization          :boolean          default(FALSE), not null
#  bio                           :text
#  card_added                    :boolean          default(FALSE), not null
#  childcare_reservation_balance :integer          default(0), not null
#  credit_balance                :integer          default(0), not null
#  email                         :string           not null
#  ios_token                     :string
#  linkedin                      :string
#  name                          :string
#  out_of_band                   :boolean          default(FALSE), not null
#  password_digest               :string
#  phone                         :string
#  remember_digest               :string
#  reset_digest                  :string
#  reset_sent_at                 :datetime
#  slug                          :string
#  superadmin                    :boolean          default(FALSE), not null
#  twitter                       :string
#  website                       :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  operator_id                   :integer          default(2), not null
#  organization_id               :integer
#  stripe_customer_id            :string
#
# Indexes
#
#  index_users_on_operator_id  (operator_id)
#

class User < ApplicationRecord
  searchkick
  # Relationships
  has_many :announcements
  has_many :checkins
  has_many :child_profiles
  has_many :childcare_reservations, through: :child_profiles
  has_many :day_passes
  has_many :door_punches
  has_many :events
  has_many :feed_items
  has_many :feed_item_comments
  has_many :invoices, as: :billable
  has_many :leads
  has_many :lead_notes
  has_many :member_feedbacks
  belongs_to :organization, optional: true
  belongs_to :operator
  has_many :operator_surveys
  has_many :reservations
  has_many :subscriptions, as: :subscribable
  has_many :refunds
  has_many :rsvps
  has_many :visits, class_name: "Ahoy::Visit"

  # Slugs
  extend FriendlyId
  friendly_id :name, use: :slugged

  # Auth stuff
  attr_accessor :remember_token, :reset_token
  before_save { self.email = email.downcase }
  validates :password, length: { minimum: 6 }, on: :create
  validates :email, uniqueness: { scope: :operator_id }
  has_secure_password

  # Scopes
  scope :approved, -> { where(approved: true) }
  scope :unapproved, -> { where(approved: false) }
  scope :archived, -> { where(archived: true) }
  scope :visible, -> { where(archived: false) }
  scope :members, -> { where(admin: false) }
  scope :admins, -> { where(admin: true) }
  scope :non_superadmins, -> { where(superadmin: false) }
  scope :for_space, ->(operator) { where("operator_id = ?", operator.id) }
  scope :superadmins, -> { where(superadmin: true) }
  scope :not_in_organization, ->(organization) { where("organization_id != ? OR organization_id IS NULL", organization.id) }

  # Permissions
  delegate  :member_at_operator?,
            :member?,
            :has_active_subscription_at_location?,
            :admin?, 
            :superadmin?, 
            :pending?, 
            :has_active_subscription?,
            :has_building_access_membership?, 
            :has_active_day_pass?, 
            :has_building_access_day_pass?, 
            :has_active_lease?, 
            :has_building_access_lease?, 
            :organization_owner?, 
            :visible?, 
            :member_of_organization?,
            :authenticated?, 
            :has_profile_photo?, 
            :checked_in?,
            :has_reservation?,
            :allowed_in?,
            :should_charge_for_reservation?,
            :can_see_all_rooms?,
            to: :user_permissions
  
  def search_data
    {
      name: name,
      email: email,
      stripe_customer_id: stripe_customer_id,
      bio: bio,
      slug: slug,
      twitter: twitter,
      organization: organization.present? ? organization.name : nil
    }
  end

  # Relationship Helpers
  def owned_organization
    Organization.where(owner_id: self.id).first
  end

  # Attachments
  has_one_attached :profile_photo

  def small_square_profile_photo
    profile_photo.variant(combine_options: { resize: "65x65>", gravity: "Center", crop: "50x50+0+0" })
  end

  def square_profile_photo
    profile_photo.variant(resize: "100x100>")
  end

  def normal_profile_photo
    profile_photo.variant(resize: "250x250")
  end

  def owned_organization
    operator.organizations.find_by(owner_id: self.id)
  end
  
  def organization_name
    if organization.present?
      organization.name
    else
      "None"
    end
  end



  # Auth Stuff
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def self.find_by_operator(params)
    email = params[:email]
    operator_id = params[:operator_id]

    user = User.find_by(email: email)
    if user.present? && user.superadmin?
      return user
    else
      return User.find_by(email: email, operator_id: operator_id)
    end
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest, User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  def send_password_reset_email
    UserMailer.password_reset(self, operator).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  # Form and view helpers
  def self.options_for_select(operator)
    User.for_space(operator).all.map do |user|
      option_helper(user)
    end
  end

  def self.lease_options_for_select(operator)
    User.for_space(operator).non_superadmins.order(:name).all.map do |user|
      option_helper(user)
    end
  end

  def self.option_helper(user)
    if user.organization.blank?
      [user.name, user.id]
    else
      ["#{user.name} (Organization: #{user.organization.name})", user.id]
    end
  end

  # Stripe Stuff
  def stripe_customer
    @stripe_customer ||= operator.retrieve_stripe_customer(self)
  end

  def has_stripe_customer?
    stripe_customer_id.present?
  end

  def has_billing?
    has_stripe_customer? && (out_of_band? || card_added?)
  end

  def delinquent?
    stripe_customer.delinquent == true
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
    if bill_to_organization
      "Bill to Group"
    else
      if out_of_band?
        "Via cash or check"
      else
        if card_added?
            "Credit card on file"
        else
          "None"
        end
      end
    end
  end

  def user_permissions
    @user_permissions ||= UserPermissions.new(self)
  end
  class UserPermissions < SimpleDelegator
    include Permissions
  end

  private_constant :UserPermissions
end
