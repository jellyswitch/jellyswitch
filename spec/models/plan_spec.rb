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

require 'rails_helper'

RSpec.describe Plan, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
