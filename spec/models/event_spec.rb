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

require 'rails_helper'

RSpec.describe Event, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
