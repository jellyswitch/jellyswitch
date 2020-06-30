# typed: false
# == Schema Information
#
# Table name: day_pass_types
#
#  id                           :bigint(8)        not null, primary key
#  always_allow_building_access :boolean          default(FALSE), not null
#  amount_in_cents              :integer          default(0), not null
#  available                    :boolean          default(TRUE), not null
#  code                         :string
#  name                         :string           not null
#  visible                      :boolean          default(TRUE), not null
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  operator_id                  :integer          not null
#

class DayPassType < ApplicationRecord
  has_many :day_passes
  belongs_to :operator
  acts_as_tenant :operator

  has_rich_text :description

  # Scopes
  scope :available, -> { where(available: true) }
  scope :visible, -> { where(visible: true) }
  scope :invisible, -> { where(visible: false) }
  scope :free, -> { where(amount_in_cents: 0) }
  scope :for_operator, ->(operator) { where(operator_id: operator.id) }
  scope :for_code, -> (code) { where(code: code) }
  scope :cheapest, -> { order('amount_in_cents ASC').first }

  def self.options_for_select(operator)
    where(operator_id: operator.id).available.visible
  end

  def self.all_options_for_select(operator)
    where(operator_id: operator.id).available
  end

  def free?
    amount_in_cents == 0
  end
end
