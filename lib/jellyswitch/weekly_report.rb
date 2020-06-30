class Jellyswitch::WeeklyReport
  include ActionView::Helpers::NumberHelper
  attr_reader :week_start, :week_end, :report, :operator, :day_passes, :checkins, :new_active_members, :new_free_members, :rooms, :paid_invoices, :unpaid_invoices, :revenue, :reservations, :management_notes, :questions, :unanswered_questions, :admins

  delegate :active_member_count, :free_member_count, :active_lease_member_count, to: :report

  def initialize(operator, week_start, week_end)
    @week_start = week_start
    @week_end = week_end
    @operator = operator

    @report = Jellyswitch::Report.new(operator)

    @day_passes = operator.day_passes.for_week(@week_start, @week_end).count
    @checkins = operator.checkins.for_week(@week_start, @week_end).count

    @new_active_members = operator.plans.individual.nonzero.map do |plan|
      plan.subscriptions.active.for_week(@week_start, @week_end).map(&:subscribable)
    end.flatten.uniq.count
    @new_free_members = operator.plans.individual.free.map do |plan|
      plan.subscriptions.active.for_week(@week_start, @week_end).map(&:subscribable)
    end.flatten.uniq.count

    @reservations = operator.rooms.map do |room|
      room.reservations.for_week(@week_start, @week_end)
    end.flatten.uniq.count

    @rooms = operator.rooms.map do |room|
      count = room.reservations.for_week(@week_start, @week_end).count
      percent = @reservations == 0 ? 0 : count.to_f / @reservations.to_f
      name = room.name

      {
        percent: percent.to_f,
        name: name,
        count: count
      }
    end

    @paid_invoices = operator.invoices.for_week(@week_start, @week_end).paid
    @unpaid_invoices = operator.invoices.for_week(@week_start, @week_end).open
    @revenue = @paid_invoices.sum(:amount_due).to_f / 100.0

    @management_notes = operator.feed_items.notes.for_week(@week_start, @week_end)

    @questions = @management_notes.questions

    @unanswered_questions = @questions.unanswered

    @admins = operator.users.admins.non_superadmins
  end
end