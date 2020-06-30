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

require 'rails_helper'

RSpec.describe Lead, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
