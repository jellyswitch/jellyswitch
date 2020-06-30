task backfill_stripe_credentials: :environment do
  Operator.where(stripe_user_id: nil).each do |op|
    op.update(
      stripe_user_id: ENV['STRIPE_ACCOUNT_ID'],
      stripe_access_token: "bogus",
      stripe_refresh_token: "bogus",
      stripe_publishable_key: "bogus"
    )
  end
end

task checkout_job: :environment do
  CheckoutJob.perform_later
end

task weekly_updates: :environment do
  if Time.current.wday == 1
    WeeklyUpdateJob.perform_later
  end
end

task clean_demo: :environment do
  result = Demo::Clean.call(subdomain: 'southlakecoworking')

  if result.success?
    puts "Success!"
  else
    puts result.message
  end
end