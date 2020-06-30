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

require 'rails_helper'

RSpec.describe ChildProfile, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
