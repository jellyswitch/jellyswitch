# typed: false
class AddSubscribableToSubscriptions < ActiveRecord::Migration[5.2]
  def change
    add_reference :subscriptions, :subscribable, polymorphic: true
  end
end
