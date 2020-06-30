# typed: false
require 'rails_helper'

RSpec.describe 'Member signup', type: :system, js: true do
  let(:subdomain) { create(:subdomain) }
  let(:operator) { create(:operator, :with_location, :with_individual_plans, subdomain: subdomain.subdomain) }
  let(:admin_user) { create(:user, :admin, operator: operator) }

  before do
    ActsAsTenant.default_tenant = operator
  end

  after do
    ActsAsTenant.default_tenant = nil
  end

  context 'paying with card' do
    it 'allows a user to select a plan and become a member' do
      new_member_session do |new_member|
        new_member.sign_up
        new_member.choose_membership
        new_member.choose_plan
        new_member.add_card
        new_member.wait_for_approval
      end

      admin_session do |admin|
        admin.sign_in
        admin.approve_member
      end

      new_member_session do |new_member|
        new_member.refresh

        expect(page).to have_content 'Send us a note'
      end
    end
  end
end
