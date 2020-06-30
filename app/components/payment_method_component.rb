class PaymentMethodComponent < ApplicationComponent
  def initialize(billable:)
    @billable = billable
  end

  private

  attr_reader :billable

  def card_added?
    billable.card_added?
  end

  def last_4_digits
    billable.card_last_4_digits # XXX extract this into a concern on the user / organization model
  end

  def credit_card_path
    if user?
      user_credit_card_path(billable)
    else
      organization_credit_card_path(billable)
    end
  end

  def cash_or_check?
    billable.out_of_band?
  end

  def cash_or_check_path
    if user?
      user_out_of_band_path(billable)
    else
      organization_out_of_band_path(billable)
    end
  end

  def billable_to_group?
    user?
  end

  def bill_to_group?
    billable_to_group? && billable.bill_to_organization?
  end

  def member_of_group?
    billable_to_group? && billable.member_of_organization?
  end

  def bill_to_group_path
    if billable_to_group?
      user_bill_to_organization_path(billable)
    else
      raise "Cannot bill to group for a group."
    end
  end

  def group_name
    if user?
      billable.organization.name
    else
      billable.name
    end
  end

  def user?
    billable.class == User
  end

  def group?
    billable.class == Organization
  end
end