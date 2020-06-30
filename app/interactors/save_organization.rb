# typed: true
class SaveOrganization
  include Interactor

  delegate :organization, :operator, to: :context

  def call
    if organization.save
      context.billable = organization
    else
      context.fail!(message: 'Could not save organization.')
    end
  end

  def rollback
    context.organization.destroy
  end
end
