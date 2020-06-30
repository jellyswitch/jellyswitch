# == Schema Information
#
# Table name: childcare_reservations
#
#  id                :bigint(8)        not null, primary key
#  cancelled         :boolean          default(FALSE), not null
#  date              :date             not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  child_profile_id  :integer          not null
#  childcare_slot_id :integer          not null
#

require 'rails_helper'

RSpec.describe ChildcareReservation, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
