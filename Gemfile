source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.7'
gem 'dotenv-rails', require: 'dotenv/rails-now'
gem "actionview-component"
gem 'activejob-traffic_control'
gem 'acts_as_tenant', '0.4.2'
gem 'ahoy_matey'
gem "aws-sdk-s3", require: false
gem 'bcrypt'
gem 'bootstrap', '~> 4.3.1'
gem 'chartkick'
gem 'draper'
gem 'faker', :git => 'https://github.com/stympy/faker.git', :branch => 'master'
gem 'fcm'
gem 'friendly_id'
gem 'groupdate'
gem 'houston'
gem 'httparty'
gem 'icalendar'
gem 'image_processing', '~> 1.2'
gem "interactor-rails", "~> 2.2.0"
gem 'jbuilder', '~> 2.5'
gem 'jquery-rails'
gem 'mail_hatch' #, path: "/Users/dave/projects/jellyswitch/mail_hatch"
gem 'momentjs-rails', '>= 2.9.0'
gem 'money'
gem 'newrelic_rpm'
gem 'octicons_helper'
gem 'pagy'
gem 'pg'
gem 'premailer-rails'
gem 'puma', '~> 3.12'
gem 'pundit'
gem 'rails', '~> 6.0.2.1'
gem 'rails_autolink'
gem 'redis'
gem 'remotipart', '~> 1.2'
gem 'roadie-rails', '~> 2.0'
gem 'request_store'
gem 'rollbar'
gem 'sass-rails', '~> 5.0'
gem 'searchkick'
gem 'sidekiq'
gem "simple_calendar", "~> 2.0"
gem 'stripe', git: 'https://github.com/stripe/stripe-ruby'
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'
gem 'webpacker', '~> 4.x'
gem 'working_hours'

group :development do
  gem 'annotate'
  gem 'attractor'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'rails-erd'
  gem 'user-auth', git: "https://github.com/dpaola2/user-auth"
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'capybara', '>= 2.15', '< 4.0'
  gem 'selenium-webdriver'
  gem 'webdrivers', '~> 3.0'
end

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'pry-rails'
  gem 'pry-byebug'
  gem 'rails-controller-testing'
  gem 'rspec-rails', '~> 3.8'
  gem "rspec_junit_formatter"
  gem 'factory_bot_rails', '~> 5.0.1'
end
