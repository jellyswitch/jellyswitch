# typed: strong
# == Schema Information
#
# Table name: operator_surveys
#
#  id                :bigint(8)        not null, primary key
#  location          :string
#  number_of_members :integer
#  operator_email    :string
#  operator_name     :string
#  space_name        :string
#  square_footage    :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  operator_id       :integer
#  user_id           :integer
#

class OperatorSurvey < ApplicationRecord
  belongs_to :operator
  belongs_to :user
  
end
