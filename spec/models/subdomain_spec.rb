# typed: false
# == Schema Information
#
# Table name: subdomains
#
#  id         :bigint(8)        not null, primary key
#  in_use     :boolean          default(FALSE), not null
#  subdomain  :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Subdomain, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
