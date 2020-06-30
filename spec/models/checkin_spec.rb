# typed: false
# == Schema Information
#
# Table name: checkins
#
#  id            :bigint(8)        not null, primary key
#  billable_type :string
#  datetime_in   :datetime         not null
#  datetime_out  :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  billable_id   :bigint(8)
#  invoice_id    :integer
#  location_id   :integer          not null
#  user_id       :integer          not null
#
# Indexes
#
#  index_checkins_on_billable_type_and_billable_id  (billable_type,billable_id)
#

require 'rails_helper'

RSpec.describe Checkin, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
