# typed: strict
Rails.application.routes.draw do
  constraints subdomain: "apply" do
    # Typeform
    get :welcome, to: "landing#welcome"
  end
  constraints subdomain: "stats" do
    require 'sidekiq/web'
    mount Sidekiq::Web => '/sidekiq'
  end
  constraints subdomain: "app" do
    # Root
    get '/', to: "landing#index"

    # Typeform
    get :welcome, to: "landing#welcome"

    # Authentication
    delete "/logout", to: "sessions#destroy", as: :logout
    post "/login", to: "sessions#create", as: :operator_login_create
    get "/login", to: "sessions#new", as: :operator_login
    get "/signup", to: "onboarding#new_user", as: :operator_signup
    get "/choose_operator", to: "sessions#choose_operator", as: :choose_operator
    get "/password_form", to: "sessions#password_form", as: :password_form
    post "/real_login", to: "sessions#real_create", as: :real_login

    get :stripe_connect_setup, to: "landing#stripe_connect_setup", as: :stripe_connect_setup

    resources :onboarding do
      collection do
        get :new_user
        post :create_user
        get :new_user_info
        post :create_user_and_locations
        get :choose_events
        get :add_event
        post :create_event
        get :daily_tasks
        post :create_daily_tasks
        get :favorite_parts
        post :create_favorite_parts
        get :finalize
      end
    end
    resources :operators
    resources :operator_surveys do
      collection do
        get :wait, to: "operator_surveys#wait"
      end
    end
    resources :webhooks do
      collection do
        post :stripe, to: "webhooks#stripe"
      end
    end
    resources :users
  end

  # Privacy Policy

  get "/privacy-policy", to: "operator/landing#privacy_policy"

  # Operator root
  root "operator/landing#index"

  # Operator Authentication
  delete "/logout", to: "operator/sessions#destroy", as: :operator_logout
  get "/logout", to: "sessions#destroy"
  post "/login", to: "operator/sessions#create"
  get "/login", to: "operator/sessions#new"
  get "/signup", to: "operator/users#new"

  # Landing
  get "landing/index", to: "operator/landing#index", as: :landing
  get "/home", to: "operator/landing#home"
  get "/wait", to: "operator/landing#wait"
  get "/choose", to: "operator/landing#choose"
  get "/activate", to: "operator/landing#activate"
  post "/activate_membership", to: "operator/landing#activate_membership"
  get "/upgrade", to: "operator/landing#upgrade"

  # Other
  get "/members_resources", to: "operator/landing#members_resources", as: :members_resources # TODO delete this
  get "/members_groups", to: "operator/landing#members_groups", as: :members_groups
  get "/offices_leases", to: "operator/landing#offices_leases", as: :offices_leases
  get "/plans_day_passes", to: "operator/landing#plans_day_passes", as: :plans_day_passes
  get "/customization", to: "operator/landing#customization", as: :customization
  get "/announcements_events", to: "operator/landing#announcements_events", as: :announcements_events

  # Admin namespace (for operator resources)
  namespace :operator do
    namespace :admin do
      resources :subscriptions do
        collection do
          post :confirm
          get :choose_start_date
        end
      end
      resources :day_passes
    end
  end

  # Alphabetized Member Resources
  resources :accounting, controller: "operator/accounting" do
    collection do
      get "expenses", to: "operator/accounting#expenses", as: :expenses
      get "update_expenses", to: "operator/accounting#update_expenses"
    end
  end
  resources :announcements, controller: "operator/announcements"
  resources :app_configs, controller: "operator/app_configs"
  resources :checkins, controller: "operator/checkins" do
    collection do
      get :required, to: "operator/checkins#required"
    end
  end
  resources :childcare, controller: "operator/childcare"
  resources :child_profiles, controller: "operator/child_profiles"
  resources :childcare_reservations, controller: "operator/childcare_reservations" do
    collection do 
      get :select_slot, to: "operator/childcare_reservations#select_slot"
    end
  end
  resources :childcare_slots, controller: "operator/childcare_slots"
  resources :childcare_reservation_purchases, controller: "operator/childcare_reservation_purchases" do
    collection do
      post :confirm, to: "operator/childcare_reservation_purchases#confirm"
    end
  end
  resources :credit_purchases, controller: "operator/credit_purchases" do
    collection do
      get :confirm, to: "operator/credit_purchases#confirm"
    end
  end
  resources :day_passes, controller: "operator/day_passes" do
    collection do
      get :code, to: "operator/day_passes#code"
      post :code, to: "operator/day_passes#redeem_code"
      get :redeem_paid, to: "operator/day_passes#redeem_paid"
    end
  end
  resources :day_pass_types, controller: "operator/day_pass_types" do
    get :available, to: "operator/day_pass_types#available"
    get :visible, to: "operator/day_pass_types#visible"
    get :always_allow_building_access, to: "operator/day_pass_types#always_allow_building_access"
  end
  resources :doors, controller: "operator/doors" do
    get "open", to: "operator/doors#open"
    collection do
      get "keys", to: "operator/doors#keys"
    end
  end
  resources :door_punches, controller: "operator/door_punches"
  resources :events, controller: "operator/events" do
    collection do
      get :past, to: "operator/events#past"
    end
    resources :analytics, controller: "operator/events/analytics"
    resources :rsvps, controller: "operator/rsvps" do
      collection do
        get :going, to: "operator/rsvps#going"
        get :not_going, to: "operator/rsvps#not_going"
        get :register, to: "operator/rsvps#register"
        get :login, to: "operator/rsvps#login"
      end
    end
  end
  resources :feed_items, controller: "operator/feed_items" do
    collection do
      get :questions
      get :activity
      get :notes
      get :financial
    end
    member do
      post "set_expense_status"
      post "unset_expense_status"
    end
    resources :comments, controller: "operator/feed_item_comments", only: [:create]
  end
  resources :invoices, only: [:index, :new, :create], controller: "operator/invoices" do
    resources :refunds, only: [:create], controller: "operator/refunds"
    get :mark_paid, to: "operator/mark_invoices_paid#update"
    collection do
      get :groups, to: "operator/invoices#groups"
      get :open, to: "operator/invoices#open"
      get :recent, to: "operator/invoices#recent"
      get :delinquent, to: "operator/invoices#delinquent"
    end
    get :charge
  end
  resources :leads, controller: "operator/leads"
  resources :lead_notes, controller: "operator/lead_notes"
  resources :locations, controller: "operator/locations" do 
    get :allow_hourly, to: "operator/locations#allow_hourly"
    get :new_users_get_free_day_pass, to: "operator/locations#new_users_get_free_day_pass"
    get :visible, to: "operator/locations#visible"
  end
  resources :member_feedbacks, controller: "operator/member_feedbacks"
  resources :modules, controller: "operator/modules" do
    collection do
      get :announcements
      get :bulletin_board
      get :childcare
      get :credits
      get :crm
      get :door_integration
      get :events
      get :offices
      get :rooms
      get :reservation_credits_settings
      get :childcare_reservations_settings
    end
  end
  resources :notifications, controller: "operator/notifications" do
    collection do
      get :checkins
      get :day_passes
      get :feedback
      get :memberships
      get :posts
      get :reservations
      get :refunds
      get :signups
    end
  end
  resources :onboarding, controller: "operator/onboarding", as: :operator_onboarding do
    collection do
      get :new_membership_plan
      post :create_membership_plan
      get :new_day_pass_type
      post :create_day_pass_type
      get :new_room
      post :create_room
      get :add_members
      get :new_member
      post :create_member
      get :new_stripe_members
      post :create_stripe_members
      get :new_kisi
      post :create_kisi
      get :new_door
      post :create_door
      post :destroy_door
      get :skip
    end
  end
  resources :offices, controller: "operator/offices" do
    collection do
      get :available, to: "operator/offices#available"
      get :upcoming_renewals, to: "operator/offices#upcoming_renewals"
    end
  end
  resources :office_leases, controller: "operator/office_leases"
  resources :organizations, controller: "operator/organizations" do
    post :add_member, to: "operator/organization_members#create"
    get :billing, to: "operator/organizations#billing"
    post :billing, to: "operator/organization_billing#create"
    get :credit_card, to: "operator/organizations#credit_card"
    get :invoices, to: "operator/organizations#invoices"
    get :leases, to: "operator/organizations#leases"
    get :ltv, to: "operator/organizations#ltv"
    get :members, to: "operator/organizations#members"
    get :out_of_band, to: "operator/organizations#out_of_band"
    get :payment_method, to: "operator/organizations#payment_method"
  end
  resources :operators, as: :operator_operators, controller: "operator/operators" do
    get :approval_required, to: "operator/operators#approval_required"
    get :checkin_required, to: "operator/operators#checkin_required"
    get :stripe_connect_setup, to: "operator/operators/stripe_connect_setup"
  end
  resources :password_resets, only: [:new, :create, :edit, :update], controller: "operator/password_resets"
  resources :plans, controller: "operator/plans" do
    get :toggle_visibility, to: "operator/plans#toggle_visibility"
    get :toggle_availability, to: "operator/plans#toggle_availability"
    get :toggle_building_access, to: "operator/plans#toggle_building_access"
    post :unarchive, to: "operator/plans#unarchive"
    collection do 
      get :archived, to: "operator/plans#archived"
    end
  end
  resources :posts, controller: "operator/posts"
  resources :post_replies, controller: "operator/post_replies", only: [:create]
  resources :reports, controller: "operator/reports" do
    collection do
      get :member_csv
      get :active_members
      get :active_lease_members
      get :active_leases
      get :last_30_day_passes
      get :total_members
      get :membership_breakdown
      get :revenue
      get :monetization
      get :checkins
    end
  end
  resources :reservations, controller: "operator/reservations", except: [:index, :new, :create] do
    collection do
      get :choose_day, to: "operator/reservations#choose_day"
      get :choose_time, to: "operator/reservations#choose_time"
      post :choose_time_post, to: "operator/reservations#choose_time_post"
      get :choose_duration, to: "operator/reservations#choose_duration"
      get :confirm, to: "operator/reservations#confirm"
      get :create_reservation, to: "operator/reservations#create_reservation"
      post :update_billing_and_create_reservation, to: "operator/reservations#update_billing_and_create_reservation"
      get :today, to: "operator/reservations#today"
    end
  end
  resources :rooms, controller: "operator/rooms", except: [:destroy] do
    get "day/:day/:month/:year", to: "operator/rooms#day", as: :day_availability
  end
  resources :search_results, only: [:new, :create], controller: "operator/search_results" do
    collection do
      get :query, to: "operator/search_results#query"
    end
  end
  resource :set_location, only: [:edit, :update], controller: "operator/set_location"
  resources :subscriptions, controller: "operator/subscriptions"
  resources :users, controller: "operator/users" do
    collection do
      get "add_member", to: "operator/users#add_member"
      get :archived, to: "operator/users#archived"
      get :unapproved, to: "operator/users#unapproved"
    end
    get :about, to: "operator/users#about"
    post :add_childcare_reservations, to: "operator/users#add_childcare_reservations"
    post :add_credits, to: "operator/users#add_credits"
    get :admin_day_passes, to: "operator/users#admin_day_passes"
    get :admin_invoices, to: "operator/users#admin_invoices"
    get :approve, to: "operator/users#approve"
    get :archive, to: "operator/users#archive"
    get :billing, to: "operator/users#edit_billing"
    post :billing, to: "operator/users#update_billing"
    get :bill_to_organization, to: "operator/users#bill_to_organization"
    get :checkins, to: "operator/users#checkins"
    get :childcare, to: "operator/users#childcare"
    get :credit_card, to: "operator/users#credit_card"
    get :credits, to: "operator/users#credits"
    get "change_password", to: "operator/users#change_password"
    get :day_passes, to: "operator/users#day_passes"
    get :invoices, to: "operator/users#invoices"
    get :ltv, to: "operator/users#ltv"
    get :membership, to: "operator/users#membership"
    get :memberships, to: "operator/users#memberships"
    get :out_of_band, to: "operator/users#out_of_band"
    get :organization, to: "operator/users#organization"
    get :past_reservations, to: "operator/users#past_reservations"
    get :payment_method, to: "operator/users#payment_method"
    get :remove_from_organization, to: "operator/users#remove_from_organization"
    get :reservations, to: "operator/users#reservations"
    get :set_password_and_send_email, to: "operator/users#set_password_and_send_email"
    get :unapprove, to: "operator/users#unapprove"
    get :unarchive, to: "operator/users#unarchive"
    get :usage, to: "operator/users#usage"
    patch "update_password", to: "operator/users#update_password"
    patch "update_organization", to: "operator/users#update_organization"
    patch "update_payment_method", to: "operator/users#update_payment_method"
  end
  resources :weekly_updates, controller: "operator/weekly_updates"
end
