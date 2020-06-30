# typed: true
class Billing::Payment::SetToBillOrganization
  include Interactor

  delegate :user, to: :context

  def call
    if user.member_of_organization?
      if user.organization.has_billing?
        if !user.update(bill_to_organization: true, out_of_band: false)
          context.fail!(message: "An error occurred.")
        end
      else
        context.fail!(message: "Group #{user.organization.name} has no billing info on file.")
      end
    else
      context.fail!(message: "User is not a member of a group.")
    end

  end
end