# typed: true
class Billable::DayPass < SimpleDelegator
  attr_accessor :billable, :day_pass

  def initialize(day_pass)
    @day_pass = day_pass
  end

  def billable
    if day_pass.user.bill_to_organization? && day_pass.user.member_of_organization? && day_pass.user.organization.present?
      day_pass.user.organization
    else
      day_pass.user
    end
  end
end