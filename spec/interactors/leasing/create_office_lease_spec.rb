# typed: false
require 'rails_helper'

RSpec.describe Billing::Leasing::CreateOfficeLease do
  let(:office_lease) { build(:office_lease) }
  subject(:context) { 
    described_class.call(
      office_lease: office_lease,
      operator: office_lease.operator,
      plan: office_lease.subscription.plan
    )
  }

  describe '#call' do
    before do
      plan = office_lease.operator.plans.lease.first
      office_lease.subscription_attributes = {
        plan_id: plan.id,
        subscribable_type: 'Organization',
        subscribable_id: office_lease.organization_id
      }
    end

    it 'subscribes the organization to the lease plan' do
      office_lease = context.office_lease
      organization = office_lease.organization
      subscription = organization.subscriptions.first

      expect(office_lease.end_date).to eq(office_lease.start_date + 1.year)
      expect(subscription.subscribable).to eq organization
    end
  end
end
