# typed: false
class MigrateUserToSubscribable < ActiveRecord::Migration[5.2]
  def change
    subscriptions = Subscription.all

    reversible do |dir|
      dir.up do
        subscriptions.each do |subscription|
          if subscription.user_id
            user = User.find(subscription.user_id) if subscription.user_id
            subscription.subscribable = user
            subscription.save!
          end
        end

        remove_reference :subscriptions, :user, index: true
      end

      dir.down do
        add_reference :subscriptions, :user, index: true, foreign_key: true

        subscriptions.each do |subscription|
          if subscription.subscribable_type == 'User'
            subscription.user_id = subscription.subscribable_id
            subscription.save!
          end
        end
      end
    end
  end
end
