# == Schema Information
#
# Table name: leads
#
#  id            :bigint(8)        not null, primary key
#  status        :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  ahoy_visit_id :integer
#  operator_id   :integer          not null
#  user_id       :integer          not null
#

FactoryBot.define do
  factory :lead do
    user_id { 1 }
    ahoy_visit_id { 1 }
    status { "MyString" }
    operator_id { 1 }
  end
end
