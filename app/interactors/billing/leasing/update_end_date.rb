# typed: true
class Billing::Leasing::UpdateEndDate
  include Interactor

  delegate :office_lease, to: :context

  def call
    context.old_end_date = office_lease.end_date
    office_lease.update(end_date: Time.current)
  end

  def rollback
    office_lease.update(end_date: context.old_end_date)
  end
end