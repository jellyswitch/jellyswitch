# typed: false
# == Schema Information
#
# Table name: member_feedbacks
#
#  id          :bigint(8)        not null, primary key
#  anonymous   :boolean          default(FALSE), not null
#  comment     :text
#  rating      :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  operator_id :integer          not null
#  user_id     :integer
#

class MemberFeedback < ApplicationRecord
  belongs_to :operator
  belongs_to :user

  acts_as_tenant :operator

  scope :recent, ->() { where('created_at > ?', Time.now - 7.days) }

  def anonymous?
    self.anonymous == true
  end
end
