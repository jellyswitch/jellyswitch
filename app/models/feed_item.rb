# typed: false
# == Schema Information
#
# Table name: feed_items
#
#  id          :bigint(8)        not null, primary key
#  blob        :jsonb            not null
#  expense     :boolean          default(FALSE), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  operator_id :integer          not null
#  user_id     :integer
#
# Indexes
#
#  index_feed_items_on_blob  (blob) USING gin
#

class FeedItem < ApplicationRecord
  MONTHS = [["Select Month", ""], ["January", 1], ["February", 2], ["March", 3], ["April", 4], ["May", 5], ["June", 6], ["July", 7], ["August", 8], ["September", 9], ["Octobor", 10], ["November", 11], ["December", 12]]
  searchkick
  has_many_attached :photos
  # Relationships
  belongs_to :operator
  belongs_to :user
  has_many :feed_item_comments

  validate :photo_files_accepted

  acts_as_tenant :operator

  scope :for_operator, ->(operator) { where(operator: operator) }
  scope :for_week, -> (week_start, week_end) { where('feed_items.created_at > ? and feed_items.created_at <= ?', week_start, week_end) }
  scope :expenses, -> { where(expense: true) }

  # Types of feed_items
  scope :member_feedbacks, -> { where("blob->> 'type' = ?", "feedback") }
  scope :childcare_reservations, -> { where("blob->> 'type' = ?", "childcare-reservation") }
  scope :day_passes, -> { where("blob->> 'type' = ?", "day-pass") }
  scope :reservations, -> { where("blob->> 'type' = ?", "reservation") }
  scope :announcements, -> { where("blob->> 'type' = ?", "announcement") }
  scope :questions, -> { where("blob->> 'text' LIKE '%\?%'") }
  scope :activity, -> { where("blob->> 'type' IN (?, ?, ?, ?, ?)", "feedback", "day-pass", "reservation", "subscription", "checkin") }
  scope :notes, -> { where("blob->> 'type' = ? AND expense = ?", "post", false) }
  scope :financial, -> { where("blob->> 'type' IN (?) OR expense = ?", "refund", true) }
  scope :expenses, -> { where(expense: true) }
  scope :unanswered, -> { left_outer_joins(:feed_item_comments).where('feed_item_comments.id IS NULL') }
  scope :answered, -> { left_outer_joins(:feed_item_comments).where('feed_item_comments.id IS NOT NULL') }

  def search_data
    {
      text: text,
      type: type,
      amount: amount,
      user_name: user.present? ? user.name : "Anonymous",
      comments: feed_item_comments.map(&:comment),
      stripe_customer_id: user.present? ? user.stripe_customer_id : nil,
    }
  end

  def action_text
    case type
    when "announcement"
      "posted an announcement"
    when "childcare-reservation"
      "made a childcare reservation"
    when "reservation"
      "reserved a room"
    when "feedback"
      "left feedback"
    when "refund"
      "was issued a refund"
    when "subscription"
      "became a member"
    when "day-pass"
      "bought a day pass"
    when "post"
      if expense?
        "posted an expense"
      else
        "posted a mgmt note"
      end
    when "checkin"
      "checked in"
    when "new-user"
      "signed up"
    when "weekly-update"
      "Your weekly update has been posted"
    end
  end

  def requires_approval?
    ["subscription", "day-pass", "new-user", "reservation"].any? {|t| type == t}
  end

  def weekly_update?
    type == "weekly-update"
  end

  def text
    blob["text"]
  end

  def type
    blob["type"]
  end

  def amount
    blob["amount"]
  end

  def has_photos?
    photos.count > 0
  end

  def feed_photos
    photos.map do |photo|
      photo.variant(combine_options: { auto_orient: true })
    end
  end

  def thumbnails
    photos.map do |photo|
      photo.variant(resize: "180x180", auto_orient: true)
    end
  end

  def is_expense_feed?
    (self.text && self.text.downcase.include_any?(["spent", "expense", "expenditure"])) ? true : false
  end

  def parse_amount
    if text.present?
      raw = text.scan(/\$\d+.*\d+/).first
      if raw.present?
        amount = (raw.tr!("$", "").to_f * 100).to_i
        blob["amount"] = amount
      end
    end
  end

  def set_expense
    self.expense = true
  end

  def unset_expense
    self.expense = false
  end

  # Lazy relationships

  def announcement
    blob_relation("announcement_id", Announcement.unscoped)
  end

  def childcare_reservation
    blob_relation("childcare_reservation_id", ChildcareReservation.unscoped)
  end

  def reservation
    blob_relation("reservation_id", Reservation.unscoped)
  end

  def member_feedback
    blob_relation("member_feedback_id", MemberFeedback.unscoped)
  end

  def day_pass
    blob_relation("day_pass_id", DayPass.unscoped)
  end

  def subscription
    blob_relation("subscription_id", Subscription)
  end

  def checkin
    blob_relation("checkin_id", Checkin)
  end

  def weekly_update
    blob_relation("weekly_update_id", WeeklyUpdate)
  end

  def invoice
    invoice_id = blob["invoice_id"]

    Invoice.find_by(id: invoice_id)
  end

  private

  VALID_ATTACHMENT_REGEX = /image\/(jpeg|jpg|png|gif)/

  def photo_files_accepted
    if photos.any? { |photo| !photo.content_type.match VALID_ATTACHMENT_REGEX }
      errors.add(:photos, "must be of file type .jpeg, .jpg, .png, or .gif")
    end
  end

  def blob_relation(key, klass)
    rel_id = blob[key]
    if rel_id.nil?
      nil
    else
      klass.find(rel_id)
    end
  end
end
