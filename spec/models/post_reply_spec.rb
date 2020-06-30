# == Schema Information
#
# Table name: post_replies
#
#  id         :bigint(8)        not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :integer          not null
#  user_id    :integer          not null
#

require 'rails_helper'

RSpec.describe PostReply, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
