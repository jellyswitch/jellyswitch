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

require 'rails_helper'

RSpec.describe DayPassType, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
