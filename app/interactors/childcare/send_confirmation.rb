class Childcare::SendConfirmation
  include Interactor

  delegate :operator, :child_profile, :childcare_slot, :childcare_reservation, :date, to: :context

  def call
    JellyswitchMail.new(operator, dry_run: !Rails.env.production?).childcare_confirmation(childcare_reservation, childcare_reservation.child_profile.user)
  end
end