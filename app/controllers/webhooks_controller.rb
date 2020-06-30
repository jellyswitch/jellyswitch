# typed: false
class WebhooksController < ApplicationController
  protect_from_forgery except: :stripe

  def stripe
    payload = JSON.parse(request.body.read, symbolize_names: true)
    @event = Stripe::Event.construct_from(payload)

    case @event.type
    when "invoice.finalized"
      if Invoice.exists?(stripe_invoice_id: @event.data.object.id)
        update_status(@event.data.object)
      else
        result = CreateInvoice.call(stripe_invoice: @event.data.object)
        if result.success?
          ok
        else
          Rollbar.error(result.message) if @event.livemode
          error(result.message)
        end
      end
    when "invoice.payment_succeeded", "invoice.payment_failed", "invoice.voided", "invoice.marked_uncollectible"
      if Invoice.exists?(stripe_invoice_id: @event.data.object.id)
        update_status(@event.data.object)
      end
    when "customer.subscription.deleted"
      result = Webhooks::SubscriptionDeleted.call(event: @event)

      if result.success?
        ok
      else
        error(result.message)
      end
    else
      error("Unrecognized webhook type: #{@event.type}")
    end
  rescue Exception => e
    Rollbar.error(e) if @event.livemode
    error(e.message)
  end

  private

  def ok
    render plain: "OK", status: 200
  end

  def error(msg)
    render plain: "ERROR: #{msg}", status: 500
  end

  def update_status(stripe_invoice)
    result = UpdateInvoiceStatus.call(stripe_invoice: stripe_invoice)
    if result.success?
      ok
    else
      Rollbar.error(result.message) if @event.livemode
      error(result.message)
    end
  end
end