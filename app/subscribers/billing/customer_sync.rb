# typed: true
class Billing::CustomerSync
  def self.call(billable_id:, billable_type:)
    billable = billable_type.constantize.find(billable_id)
    return if billable.stripe_customer_id
    operator = billable.operator

    case billable_type
    when 'Organization'
      billable.update(out_of_band: true)
    end

    stripe_customer = operator.create_stripe_customer(billable)
    billable.update(stripe_customer_id: stripe_customer.id)
  end
end
