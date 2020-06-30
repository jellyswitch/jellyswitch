# typed: false
module StripeUtils
  STRIPE_CLASS_MAP = {
    customer: 'Customer',
    plan: 'Plan',
    subscription: 'Subscription',
    invoice: 'Invoice',
    invoice_item: 'InvoiceItem',
    refund: 'Refund',
  }

  STRIPE_CLASS_MAP.each do |key, value|
    define_method("stripe_#{key}") { value }
  end

  def create_stripe_customer(customer)
    return retrieve_stripe_customer(customer) if customer.stripe_customer_id

    case customer.class.name
    when 'User'
      customer_args = { 
        email: customer.email,
        description: customer.name
      }
    when 'Organization'
      customer_args = {
        email: customer.email,
        description: customer.name
      }
    end

    stripe_request(stripe_customer, :create, customer_args)
  end

  def retrieve_stripe_customers
    stripe_request("Customer", :list, {})
  end

  def retrieve_stripe_customer(customer)
    stripe_request(stripe_customer, :retrieve, customer.stripe_customer_id)
  end

  def retrieve_stripe_invoice(invoice)
    stripe_request(stripe_invoice, :retrieve, id: invoice.stripe_invoice_id)
  end

  def create_stripe_refund(invoice, stripe_invoice = nil)
    stripe_invoice = retrieve_stripe_invoice(invoice) unless stripe_invoice
    refund_args = { charge: stripe_invoice.charge, amount: invoice.amount_due }

    stripe_request(stripe_refund, :create, refund_args)
  end

  def retrieve_stripe_refund(refund)
    stripe_request(stripe_refund, :retrieve, id: refund.stripe_refund_id)
  end

  def create_stripe_subscription(subscription, lease: nil)
    subscribable = StripeSubscriptionFactory.for(subscription, lease)
    stripe_request(stripe_subscription, :create, subscribable.subscription_args)
  end

  def list_stripe_subscriptions
    stripe_request(Subscription, :list, {})
  end

  def create_stripe_plan(plan)
    plan_args = {
      amount: plan.amount_in_cents,
      interval: plan.stripe_interval,
      interval_count: plan.stripe_interval_count,
      product: { name: plan.plan_name },
      currency: 'usd',
      id: plan.plan_slug
    }

    stripe_request(stripe_plan, :create, plan_args)
  end

  def retrieve_stripe_plans
    stripe_request("Plan", :list, {})
  end

  def create_stripe_invoice(user)
    invoice_args = { customer: user.stripe_customer_id }

    stripe_request(stripe_invoice, :create, invoice_args)
  end

  def create_stripe_invoice_item(user, plan)
    invoice_item_args = {
      customer: user.stripe_customer_id,
      currency: 'usd',
      amount: plan.amount_in_cents,
      description: plan.name,
    }

    stripe_request(stripe_invoice_item, :create, invoice_item_args)
  end

  def charge_invoice(invoice)
    case invoice.billable_type
    when "User"
      if !invoice.billable.card_added
        raise "No card on file."
      end
    when "Organization"
      if !invoice.billable.has_billing?
        raise "No card on file."
      end
    end
    stripe_customer = invoice.billable.stripe_customer

    if stripe_customer.sources.data.count == 0
      raise "No card on file."
    end

    stripe_invoice = retrieve_stripe_invoice(invoice)

    options = {
      source: stripe_customer.sources.data.first.id
    }

    stripe_invoice.pay(options)
  rescue Stripe::InvalidRequestError => e
    Rollbar.error(e)
    false
  end

  def mark_invoice_paid(invoice, options = {})
    stripe_invoice = retrieve_stripe_invoice(invoice)

    stripe_invoice.pay(options)
  rescue Stripe::InvalidRequestError => e
    Rollbar.error(e)
    false
  end

  def create_or_update_customer_payment(user, token)
    stripe_customer = retrieve_stripe_customer(user)
    stripe_customer.source = token
    stripe_customer.save
  rescue Stripe::InvalidRequestError => e
    Rollbar.error(e)
    false
  end

  

  def stripe_request(klass, action, request_args)
    operator_stripe_credentials = {
      api_key: stripe_secret_key,
      stripe_account: stripe_user_id
    }

    stripe_args = [request_args, operator_stripe_credentials]

    "Stripe::#{klass}".constantize.public_send(action, *stripe_args)
  rescue Stripe::InvalidRequestError => e
    Rollbar.error(e)
    raise(e)
  end
end
