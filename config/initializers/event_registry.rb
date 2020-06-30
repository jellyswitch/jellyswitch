# typed: strong
# case ENV['EVENTS_CHANNEL_ADAPTER']
# when 'sidekiq'
#   Jellyswitch::Events.channel = Jellyswitch::Events::Channel::Sidekiq.instance
# when 'active_support'
#   Jellyswitch::Events.channel = Jellyswitch::Events::Channel::ActiveSupportNotification.new
# else
#   raise "Unknown Jellyswitch::Events::Channel adapter '#{Jellyswitch::Events.channel}'"
# end
#
# # Billing events
# Jellyswitch::Events.register('billing.customer.create')
# Jellyswitch::Events.subscribe('billing.customer.create', Billing::CustomerSync)
#
# Jellyswitch::Events.register('billing.lease.create')
# Jellyswitch::Events.register('billing.subscription.create')
#
# Jellyswitch::Events.subscribe('billing.lease.create', Billing::LeaseSync)
# Jellyswitch::Events.subscribe('billing.subscription.create', Billing::SubscriptionSync)
#
#
# # App events
# Jellyswitch::Events.register('app.notifiable.create')
#
# Jellyswitch::Events.subscribe('app.notifiable.create', NotificationSync)
