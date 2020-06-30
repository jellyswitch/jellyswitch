class PaymentPolicy < ApplicationPolicy
  include PolicyHelpers

  def enabled?
    operator.production?
  end
end