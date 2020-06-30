# typed: true
class InvoicePolicy < ApplicationPolicy
  include PolicyHelpers

  def index?
    admin? && billing_enabled?
  end
  
  def due?
    admin? && billing_enabled?
  end

  def recent?
    admin? && billing_enabled?
  end

  def delinquent?
    admin? && billing_enabled?
  end

  def charge?
    admin? && card_added? && billing_enabled?
  end

  def groups?
    admin? && billing_enabled?
  end

  def open?
    admin? && billing_enabled?
  end

  def new?
    admin? && billing_enabled?
  end

  def create?
    admin? && billing_enabled?
  end

  private

  def card_added?
    case record.billable_type
    when "User"
      record.billable.card_added?
    when "Organization"
      record.billable.has_billing?
    end
  end
end