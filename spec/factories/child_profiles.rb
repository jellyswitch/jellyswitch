# == Schema Information
#
# Table name: child_profiles
#
#  id         :bigint(8)        not null, primary key
#  birthday   :datetime
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#

FactoryBot.define do
  factory :child_profile do
    name { "MyString" }
    birthday { "2020-01-20 14:18:48" }
    user_id { 1 }
  end
end
