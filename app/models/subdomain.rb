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

class Subdomain < ApplicationRecord
  scope :unreserved, -> { where(in_use: false) }
  scope :reserved, -> { where(in_use: true) }
end
