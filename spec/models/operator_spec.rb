# typed: false
# == Schema Information
#
# Table name: operators
#
#  id                            :bigint(8)        not null, primary key
#  android_server_key            :string
#  android_url                   :string
#  announcements_enabled         :boolean          default(TRUE), not null
#  approval_required             :boolean          default(TRUE), not null
#  billing_state                 :string           default("demo"), not null
#  building_address              :string           default("not set"), not null
#  bulletin_board_enabled        :boolean          default(FALSE), not null
#  checkin_notifications         :boolean          default(TRUE), not null
#  checkin_required              :boolean          default(FALSE), not null
#  childcare_enabled             :boolean          default(FALSE), not null
#  contact_email                 :string
#  contact_name                  :string
#  contact_phone                 :string
#  credits_enabled               :boolean          default(FALSE), not null
#  day_pass_cost_in_cents        :integer          default(2500), not null
#  day_pass_notifications        :boolean          default(TRUE), not null
#  door_integration_enabled      :boolean          default(TRUE), not null
#  email_enabled                 :boolean          default(FALSE), not null
#  events_enabled                :boolean          default(TRUE), not null
#  ios_url                       :string
#  kisi_api_key                  :string
#  member_feedback_notifications :boolean          default(TRUE), not null
#  membership_notifications      :boolean          default(TRUE), not null
#  membership_text               :string
#  name                          :string           not null
#  offices_enabled               :boolean          default(TRUE), not null
#  post_notifications            :boolean          default(TRUE), not null
#  refund_notifications          :boolean          default(TRUE), not null
#  reservation_notifications     :boolean          default(FALSE), not null
#  rooms_enabled                 :boolean          default(TRUE), not null
#  signup_notifications          :boolean          default(FALSE), not null
#  skip_onboarding               :boolean          default(FALSE), not null
#  snippet                       :string           default("Generic snippet about the space"), not null
#  square_footage                :integer          default(0), not null
#  stripe_access_token           :string
#  stripe_publishable_key        :string
#  stripe_refresh_token          :string
#  subdomain                     :string           not null
#  wifi_name                     :string           default("not set"), not null
#  wifi_password                 :string           default("not set"), not null
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  stripe_user_id                :string
#
# Indexes
#
#  index_operators_on_subdomain  (subdomain) UNIQUE
#

require 'rails_helper'

RSpec.describe Operator, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
