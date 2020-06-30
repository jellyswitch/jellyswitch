# == Schema Information
#
# Table name: weekly_updates
#
#  id            :bigint(8)        not null, primary key
#  blob          :jsonb
#  previous_blob :jsonb
#  week_end      :datetime
#  week_start    :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  operator_id   :integer
#

require 'rails_helper'

RSpec.describe WeeklyUpdate, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
