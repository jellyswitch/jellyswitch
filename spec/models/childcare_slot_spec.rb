# == Schema Information
#
# Table name: childcare_slots
#
#  id          :bigint(8)        not null, primary key
#  capacity    :integer          default(0), not null
#  deleted     :boolean          default(FALSE), not null
#  name        :string           not null
#  week_day    :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  location_id :integer          not null
#

require 'rails_helper'

RSpec.describe ChildcareSlot, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
