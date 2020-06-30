# typed: true

class Checkins::SaveCheckin
  include Interactor

  delegate :user, :location, :operator, to: :context

  def call
    if location.operator != operator
      context.fail!(message: "Cannot check into #{location.name} for operator #{operator.name}")
    end

    checkin = Checkin.new(
      user: user,
      location: location,
      datetime_in: Time.current,
      invoice_id: nil
    )

    checkin.billable = BillableFactory.for(checkin).billable

    if !checkin.save
      context.fail!(message: "Could not check in.")
    end

    context.checkin = checkin

    context.notifiable = context.checkin
  end

  def rollback
    context.checkin.destroy
  end
end