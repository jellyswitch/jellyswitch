class Demo::Clean::Memberships
  include Interactor

  delegate :operator, to: :context

  def call
    # groups
    operator.organizations.all.each do |org|
      org.subscriptions.active.each do |subscription|
        cancel(subscription)
      end
    end

    # users
    operator.users.all.each do |user|
      user.subscriptions.active.each do |subscription|
        cancel(subscription)
      end
    end
  end

  private

  def cancel(subscription)
    result = CancelSubscription.call(subscription: subscription)
    if result.success?
      subscription.delete
    else
      context.fail!(message: result.message)
    end
  end
end