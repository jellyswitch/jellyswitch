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

FactoryBot.define do
  factory :weekly_update do
    operator_id { 1 }
    blob { "" }
    week_start { "2019-07-16 17:05:06" }
    week_end { "2019-07-16 17:05:06" }
  end
end
