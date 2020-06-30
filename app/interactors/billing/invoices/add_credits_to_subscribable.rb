class Billing::Invoices::AddCreditsToSubscribable
  include Interactor

  delegate :invoice, to: :context

  def call
    stripe_invoice = invoice.stripe_invoice
    if stripe_invoice.lines.count > 0
      if stripe_invoice.lines.first.respond_to? :subscription
        subscription = invoice.operator.subscriptions.find_by(stripe_subscription_id: invoice.stripe_invoice.lines.first.subscription)
        if subscription
          credits(subscription)
          childcare_reservations(subscription)
        end
      end
    end
  end

  def credits(subscription)
    if invoice.operator.credits_enabled?
      if subscription.plan.credits > 0
        subscription.subscribable.update(credit_balance: subscription.plan.credits)
      end
    end
  end

  def childcare_reservations(subscription)
    if invoice.operator.childcare_enabled?
      if subscription.plan.childcare_reservations > 0
        subscription.subscribable.update(childcare_reservation_balance: subscription.plan.childcare_reservations)
      end
    end
  end
end