# typed: strict
Rails.configuration.stripe = {
  publishable_key: ENV['STRIPE_PUBLISHABLE_KEY'],
  secret_key: ENV['STRIPE_SECRET_KEY'],
  test_publishable_key: ENV['STRIPE_TEST_PUBLISHABLE_KEY'],
  test_secret_key: ENV['STRIPE_TEST_SECRET_KEY']
}
