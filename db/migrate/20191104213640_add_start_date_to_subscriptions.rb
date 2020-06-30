class AddStartDateToSubscriptions < ActiveRecord::Migration[5.2]
  def up
    add_column :subscriptions, :start_date, :date

    
    Subscription.unscoped.all.each do |subscription|
      subscription.start_date = subscription.created_at
      subscription.save(validate: false)

      if subscription.office_leases.count > 0
        subscription.update(start_date: subscription.office_leases.first.initial_invoice_date)
      else
        if subscription.has_stripe_subscription?
          begin
            date = Time.at(subscription.stripe_subscription.billing_cycle_anchor).to_date
            subscription.update(start_date: date)
          rescue StandardError => e
          end
        end
      end
    end

    change_column :subscriptions, :start_date, :date, null: false
  end

  def down
    remove_column :subscriptions, :start_date
  end
end
