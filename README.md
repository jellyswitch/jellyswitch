# Jellyswitch

Jellyswitch is a next-generation, mobile-first coworking platform that enables a superior member experience and allows coworking staff members and operators to run their daily operations quickly and effectively.

Bristlecone is the project name for the backend and mobile-first web frontend for Jellyswitch. There are associated projects for the iOS and Android applications:

- https://github.com/jellyswitch/jellyswitch-ios
- https://github.com/jellyswitch/jellyswitch-android

## Summary

Jellyswitch is a multi-tenant Ruby on Rails (6) app that uses Bootstrap for both the grid system on the frontend as well as many of the standard UI components. All javascript dependencies are managed via `webpacker`. (Almost) all billing and payments related functionality is built with Stripe Connect. We advise using Postgres as the database, due to some of the JSON and JSONB columns here and there. 

The codebase makes heavy use of the [Interactor Pattern](https://github.com/collectiveidea/interactor-rails) for most business logic (found in `app/interactors`) to keep models and controllers suitably thin. Authorization is built with [Pundit](https://github.com/varvet/pundit) and policies can be found in `app/policies`. For complex conditionals we make use of the factory pattern (found in `app/object_factories`) and the polymorphic classes themselves are found in `app/adapters`. This makes complex conditionals (nearly) nonexistent in the codebase. Jellyswitch also makes effective use of [View Components](https://github.com/github/view_component/), rendering objects with logic and state rather than partials. Find them in `app/components`.

All functionality is designed and implemented mobile-first but works great in a desktop browser as well.

:fire: The platform has been battle-tested in production for almost two years, in use by hundreds of users every single day.

We would like to thank the people outlined in `AUTHORS.md` for their contributions to making Jellyswitch great.

## Multi Tenancy

Jellyswitch uses the [acts_as_tenant](https://github.com/ErwinM/acts_as_tenant) gem to dispatch requests to the appropriate tenant based on the subdomain. A tenant in Jellyswitch is an `Operator` (see `app/models/operator.rb`).

In production, this means you must have either a DNS record for every tenant or, if your providear supports it, a wildcard entry. The same is true of SSL certificates. At Jellyswitch, we use AWS Route53 for DNS and have purchased a wildcard SSL certificate that makes this fast and simple at a minimum cost. In development, you may either add manual entries to your `/etc/hosts` file that point to `127.0.0.1` or a DNS service such as `dnsmasq`. The convention is to use `jellyswitch.org` as the local development domain.

This design choice also means that most controllers and views live inside `app/controllers/operator` and `app/views/operator`, respectively. Controllers and views outside of that directory are likely administrative.

Inside `config/routes.rb`, you will find that most routes are directed to the `operator` namespace as described. However, there are administrative routes that live solely under the `app` subdomain.

Jellyswitch's `tenant` is the `Operator` model. Operators are the "base" model for a new coworking company. An `Operator` may have many `locations`, `users`, and more. The `acts_as_tenant` gem adds a `default_scope` to some of the models that infer the tenant based on the subdomain of the current request. 

Most business-wide settings, enabled/disabled modules, and customizations live in the `Operator` record for that business. Most metadata about a single coworking space location lives on the associated `Location` records.

### Example

- A request to `demo.jellyswitch.com` will set the tenant to the `Operator` instance with the `demo` subdomain set
- Default scopes on models will filter out records *not* associated with that `Operator`

## Background Jobs

The following rake tasks are run daily (find them in `lib/tasks`):

- 6am UTC: `rake checkout_job` - Automatically check out users that have forgotten to check out
- 3pm UTC: `rake weekly_updates` - Create weekly updates, publish them to the feeds, and issue push notifications
- 9am UTC: `rake clean_demo` - Reset the demo instance and reproduce all demo data within it

## iOS, Android, and Turbolinks

Jellyswitch mobile applications are created using the [Turbolinks](https://github.com/turbolinks/turbolinks) libraries on [iOS](https://github.com/turbolinks/turbolinks-ios) and [Android](https://github.com/turbolinks/turbolinks-android) and provisioned manually into the app stores.

Once you have push notification certificates for each application, you can upload them to the associated `Operator` by visiting the `app` subdomain of your Jellyswitch instance, finding the appropriate `Operator` and simply uploading the certificate. Without this certificate, push notifications will not send successfully. On iOS, use `fastlane pem` to provision a certificate for each mobile app and upload the `.pem` file. On Android, Jellyswitch uses Firebase Cloud Messaging. Provision an appropriate app on Firebase and copy & paste the server key.

When a user hits the server with an iOS or Android device, their device will send a token as part of the user agent string. This string is saved on the `User` model and used to send push notifications.

For app icons and more, there are scripts that will automatically take correctly-sized and correctly-formatted collections of logo JPG files and copy them into both the iOS and Android projects in the root of the project. These are the `ios_images.rb` and `android_images.rb` respectively. You can use a site like https://appicon.co to create your images.

## Rooms & Reservations

This is mostly straightforward - any hacks you encounter are likely to accommodate for changes in time zones and daylight savings. If the operator has enabled paid reservations, a room may have an optional cost that is conditionally charged depending on the user's membership tier (or lack thereof).

Additionally, there is a "labs" feature for a reservation credit systm the behaves similarly - memberships have associated credits that are replenished upon successfuly invoice payment and the credits are deducted based on reservation usage. These labs features are implemented with feature flags on a per-operator basis.

## Billing & Payments

Every `Operator` must have a connected Stripe account. This allows Jellyswitch to "pass-through" all Stripe requests to the coworking business's account and simplifies the data model drastically. Connecting a Stripe account is an important early step in onboarding, as many records require a Stripe connection before the platform becomes useful.

All Stripe-associated invocations live inside the `app/models/concerns/stripe_utils.rb` mixin.

Coworking memberships and office leases are represented in the `Subscription` model, which is essentially a join table between a `Billable` polymorphic entity and a `Plan`. In practice these are instances of either a `User` or an `Organization` (a group). On the `Subscription` model, there is an additional `Subscribable` polymorphic entity that can similarly be a `User` or an `Organization`. For an office lease, we expect the `Billable` and `Subscribable` to be the same. For a coworking membership, the `Subscribable` would be a `User`, but the `Billable` could be either that `User` or its associated `Organization`. This enables the "Group Billing" feature which is essentially the ability for `users` to have memberships their employer sponsors (their associated `Organization`).

`Invoice`s are associated with `User`s and `Organizations` and are created either manually via `DayPasses` or via the manual form on the `User` or `Organization` profile screen. They are also created via a Stripe webhook (which must be registered in your Stripe dashboard for both your account and any connected accounts).

`Invoice`s may have associated `Refund` records, and their status is updated via webhook as well.

`OfficeLease`s are join tables between a `Subscription` and an `Office`. They have (mostly) the same behavior as memberships, with the notable exception of preset termination dates.

Staff members can manage the plans, offices, leases, and day pass types quickly and easily through the web or mobile screens.

## Building Access

Building access functionality can be found in the `Door` and `DoorPunch` models. Opening a `Door` means issuing an API request via the `OpenDoorJob` and each request is logged with a `DoorPunch`.

Currently the only supported building access provider is Kisi, but enabling other providers would not be difficult. The plan would be to create a `BuildingAccessProvider` model, put conditional logic into a factory, add the appropriate adapters, and you're likely set.

## Misc

For staff members, the feed is an important screen. `FeedItem` is the core model for this aspect of the product - there are several types of `feed_items` that are often created in parallel with push notifications by admins many times per day (as well as `feed_item_comments`).

The Bulletin Board is straightforward - posts and post replies. It leverages the [ActionText](https://edgeguides.rubyonrails.org/action_text_overview.html) library and as such, supports rich text, inline images, file uploads, and more.

Announcements allow staff members to push notifications directly to a user's phone in case of emergency or other scenarios.

## Getting started in development

These instructions assume a MacOS operating system. Almost all configuration lives in the `.env` file see "Environment Variables" in next section.

Ensure you have ruby 2.5.7 installed (we use [rvm](https://rvm.io).)


1. `bundle install`
2. Install [Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli)
3. Install Redis:
  - `brew install redis`
  - `brew services start redis`
4. Install Elasticsearch:
  - `brew cask install homebrew/cask-versions/java8`
  - `brew install elasticsearch`
  - `brew services start elasticsearch`
5. Install [stripe-mock](https://github.com/stripe/stripe-mock) (to speed up testing)
  - `brew install stripe/stripe-mock/stripe-mock`
  - **NOTE** stripe-mock cannot be used to test for specific errors, so be sure to turn it off in development if testing for those.
  - `brew services start stripe-mock`
6. Install `yarn`:
  - `brew install yarn`
7. Populate your `.env` file with environment variables
8. Run: `rails active_storage:install`
9. Postgres DB: `createdb bristlecone_development`
10. Run migrations: `heroku local:run rake db:migrate`
11. Run the server: `heroku local`

## Environment Variables

We follow much of the [12 factor methodology](https://12factor.net) and as such, most of our configuration is done via environment variables. This allows most code to be identical between environments such as development, testing, staging, and production.

Here is a list of variables you will want to have set in a production environment:

```
PORT
RACK_ENV
RAILS_ENV
WEB_CONCURRENCY
MAX_THREADS
HOST
BASE_URI
TIME_ZONE
REDIS_URL
AWS_BUCKET
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_REGION
GOOGLE_MAPS_API_KEY
ROLLBAR_ACCESS_TOKEN
SMTP_HOST
SMTP_PORT
STRIPE_CLIENT_ID
STRIPE_ACCOUNT_ID
STRIPE_SECRET_KEY
STRIPE_PUBLISHABLE_KEY
STRIPE_LOG
STRIPE_TEST_SECRET_KEY
STRIPE_TEST_PUBLISHABLE_KEY
ASSET_HOST
MAILHATCH_API_KEY
SENDGRID_API_KEY
```

## Data model

The [rails-erd](https://github.com/voormedia/rails-erd) library is included in the Gemfile so that you can create Entity-Relationship Diagrams for the Jellyswitch database. We recommend this - it is a reasonably large schema.

## Bootstrapping Users, Admins, and Superadmins

All users have a record in the `users` table. Staff members of coworking spaces have the `admin` flag on their user set to `true`. Jellyswitch staff, developers, and so on, have both the `admin` and `superadmin` flag set to `true`. 

All users have associated stripe customers associated with them. So it's important to have the environment variables before taking this next step.

To get started, go ahead and hope the rails console (`heroku local:run rails c`) and create a new superadmin so you can log in:

```
$ u = User.create!(name: "Zero Cool", password: "password", email: "zerocool@hackers.com", admin: true, superadmin: true, approved: true)
$ result = CreateStripeCustomer.call(user: u)
```

## Demo Instances

Create new demo instances by opening the rails console and creating `Subdomain` records:

```
[1] pry(main)> Subdomain.create!(subdomain: "demo")
[2] pry(main)> result = Demo::Clean.call(subdomain: "demo")
```

Once this interactor finishes, visit `http://demo.jellyswitch.org:3000` in your browser to see your demo instance.

## Local Elastic Search Errors

If you encounter issues w/ elastic search, try running this command: 

`curl -u elastic:changeme -XPUT 'localhost:9200/_cluster/settings' -H 'Content-Type: application/json' -d '{"persistent":{"cluster.blocks.read_only":false}}'`

Can also try PUT to `/_all/_settings` this: `{
  "index.blocks.read_only_allow_delete": false
}`

(From [https://github.com/ankane/searchkick/issues/1040](https://github.com/ankane/searchkick/issues/1040)
