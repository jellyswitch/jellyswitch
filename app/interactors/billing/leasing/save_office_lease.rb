# typed: true
class Billing::Leasing::SaveOfficeLease
  include Interactor

  delegate :office_lease, :operator, to: :context

  def call
    organization = Organization.find(office_lease.organization_id)
    subscription = office_lease.subscription
    subscription.subscribable = organization
    subscription.billable = BillableFactory.for(subscription).billable
    subscription.start_date = office_lease.initial_invoice_date

    unless office_lease.end_date
      office_lease.end_date = office_lease.start_date + 1.year
    end

    if office_lease.save
      context.office_lease = office_lease
    else
      context.fail!(message: 'Could not create lease')
    end
  end

  def rollback
    sub = context.office_lease.subscription
    context.office_lease.destroy
    sub.destroy
  end
end
