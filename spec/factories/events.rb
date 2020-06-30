# == Schema Information
#
# Table name: events
#
#  id              :bigint(8)        not null, primary key
#  description     :text
#  ends_at         :datetime
#  location_string :string
#  starts_at       :datetime         not null
#  title           :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  location_id     :integer          not null
#  user_id         :integer          not null
#

FactoryBot.define do
  factory :event do
    title { "MyString" }
    description { "MyText" }
    user_id { 1 }
    location_id { 1 }
    starts_at { "2019-09-16 10:57:12" }
    ends_at { "2019-09-16 10:57:12" }
  end
end
