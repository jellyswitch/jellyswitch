# == Schema Information
#
# Table name: leads
#
#  id            :bigint(8)        not null, primary key
#  status        :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  ahoy_visit_id :integer
#  operator_id   :integer          not null
#  user_id       :integer          not null
#

class Lead < ApplicationRecord
  belongs_to :operator
  belongs_to :user
  belongs_to :ahoy_visit, class_name: "Ahoy::Visit"

  has_many :lead_notes

  after_create :set_status
  after_create :set_source

  SOURCES = {
    web: "web",
    event: "event",
    referral: "referral"
  }

  STATUSES = {
    open: "open",
    closed_lost: "closed-lost",
    closed_won: "closed-won"
  }

  def set_status
    if status.blank?
      update(status: STATUSES[:open])
    end
  end

  def set_source
    if source.blank?
      if ahoy_visit.present?
        source.update(source: SOURCES[:web])
      end
    end
  end

  def gravatar
    hash = Digest::MD5.hexdigest(user.email)
    "https://www.gravatar.com/avatar/#{hash}"
  end
end
