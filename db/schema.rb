# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_02_21_213351) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "ahoy_events", force: :cascade do |t|
    t.bigint "visit_id"
    t.bigint "user_id"
    t.string "name"
    t.jsonb "properties"
    t.datetime "time"
    t.index ["name", "time"], name: "index_ahoy_events_on_name_and_time"
    t.index ["properties"], name: "index_ahoy_events_on_properties", opclass: :jsonb_path_ops, using: :gin
    t.index ["user_id"], name: "index_ahoy_events_on_user_id"
    t.index ["visit_id"], name: "index_ahoy_events_on_visit_id"
  end

  create_table "ahoy_visits", force: :cascade do |t|
    t.string "visit_token"
    t.string "visitor_token"
    t.bigint "user_id"
    t.string "ip"
    t.text "user_agent"
    t.text "referrer"
    t.string "referring_domain"
    t.text "landing_page"
    t.string "browser"
    t.string "os"
    t.string "device_type"
    t.string "country"
    t.string "region"
    t.string "city"
    t.float "latitude"
    t.float "longitude"
    t.string "utm_source"
    t.string "utm_medium"
    t.string "utm_term"
    t.string "utm_content"
    t.string "utm_campaign"
    t.string "app_version"
    t.string "os_version"
    t.string "platform"
    t.datetime "started_at"
    t.index ["user_id"], name: "index_ahoy_visits_on_user_id"
    t.index ["visit_token"], name: "index_ahoy_visits_on_visit_token", unique: true
  end

  create_table "announcements", force: :cascade do |t|
    t.integer "user_id"
    t.text "body"
    t.integer "operator_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "checkins", force: :cascade do |t|
    t.integer "location_id", null: false
    t.integer "user_id", null: false
    t.datetime "datetime_in", null: false
    t.datetime "datetime_out"
    t.integer "invoice_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "billable_type"
    t.bigint "billable_id"
    t.index ["billable_type", "billable_id"], name: "index_checkins_on_billable_type_and_billable_id"
  end

  create_table "child_profiles", force: :cascade do |t|
    t.string "name"
    t.datetime "birthday"
    t.integer "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "childcare_reservations", force: :cascade do |t|
    t.integer "childcare_slot_id", null: false
    t.integer "child_profile_id", null: false
    t.date "date", null: false
    t.boolean "cancelled", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "childcare_slots", force: :cascade do |t|
    t.string "name", null: false
    t.integer "week_day", null: false
    t.boolean "deleted", default: false, null: false
    t.integer "location_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "capacity", default: 0, null: false
  end

  create_table "day_pass_types", force: :cascade do |t|
    t.string "name", null: false
    t.integer "operator_id", null: false
    t.integer "amount_in_cents", default: 0, null: false
    t.boolean "available", default: true, null: false
    t.boolean "visible", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "always_allow_building_access", default: false, null: false
    t.string "code"
  end

  create_table "day_passes", force: :cascade do |t|
    t.date "day", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "stripe_charge_id"
    t.integer "operator_id", default: 1, null: false
    t.integer "day_pass_type_id"
    t.integer "invoice_id"
    t.string "billable_type"
    t.bigint "billable_id"
    t.index ["billable_type", "billable_id"], name: "index_day_passes_on_billable_type_and_billable_id"
    t.index ["operator_id"], name: "index_day_passes_on_operator_id"
  end

  create_table "door_punches", force: :cascade do |t|
    t.integer "door_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "operator_id", default: 1, null: false
    t.jsonb "json"
    t.index ["operator_id"], name: "index_door_punches_on_operator_id"
  end

  create_table "doors", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.boolean "available", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "operator_id", default: 1, null: false
    t.integer "kisi_id"
    t.bigint "location_id"
    t.index ["location_id"], name: "index_doors_on_location_id"
    t.index ["operator_id"], name: "index_doors_on_operator_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.integer "user_id", null: false
    t.integer "location_id", null: false
    t.datetime "starts_at", null: false
    t.string "location_string"
    t.datetime "ends_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "feed_item_comments", force: :cascade do |t|
    t.integer "feed_item_id", null: false
    t.integer "user_id", null: false
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "feed_items", force: :cascade do |t|
    t.integer "operator_id", null: false
    t.integer "user_id"
    t.jsonb "blob", default: "{}", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "expense", default: false, null: false
    t.index ["blob"], name: "index_feed_items_on_blob", using: :gin
  end

  create_table "friendly_id_slugs", id: :serial, force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "invoices", force: :cascade do |t|
    t.string "stripe_invoice_id"
    t.integer "amount_due"
    t.integer "amount_paid"
    t.datetime "date"
    t.string "status"
    t.string "number"
    t.integer "operator_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "due_date"
    t.string "billable_type"
    t.bigint "billable_id"
    t.index ["billable_type", "billable_id"], name: "index_invoices_on_billable_type_and_billable_id"
  end

  create_table "lead_notes", force: :cascade do |t|
    t.integer "lead_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "leads", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "ahoy_visit_id"
    t.string "status"
    t.integer "operator_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "source"
  end

  create_table "locations", force: :cascade do |t|
    t.string "name"
    t.bigint "operator_id", null: false
    t.string "billing_state"
    t.string "building_address"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.string "contact_email"
    t.string "contact_name"
    t.string "contact_phone"
    t.string "snippet"
    t.integer "square_footage"
    t.string "stripe_access_token"
    t.string "stripe_publishable_key"
    t.string "stripe_refresh_token"
    t.string "wifi_name"
    t.string "wifi_password"
    t.string "working_day_start", default: "09:00", null: false
    t.string "working_day_end", default: "18:00", null: false
    t.string "stripe_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "time_zone", default: "Pacific Time (US & Canada)", null: false
    t.boolean "visible", default: true, null: false
    t.integer "flex_square_footage", default: 0, null: false
    t.integer "common_square_footage", default: 0, null: false
    t.string "building_access_instructions"
    t.boolean "allow_hourly", default: false, null: false
    t.integer "hourly_rate_in_cents", default: 0, null: false
    t.boolean "new_users_get_free_day_pass", default: false, null: false
    t.boolean "open_sunday", default: false, null: false
    t.boolean "open_monday", default: true, null: false
    t.boolean "open_tuesday", default: true, null: false
    t.boolean "open_wednesday", default: true, null: false
    t.boolean "open_thursday", default: true, null: false
    t.boolean "open_friday", default: true, null: false
    t.boolean "open_saturday", default: false, null: false
    t.integer "credit_cost_in_cents", default: 0, null: false
    t.integer "childcare_reservation_cost_in_cents", default: 0, null: false
    t.index ["operator_id"], name: "index_locations_on_operator_id"
    t.index ["state", "city"], name: "index_locations_on_state_and_city"
    t.index ["zip"], name: "index_locations_on_zip"
  end

  create_table "locations_plans", id: false, force: :cascade do |t|
    t.bigint "plan_id"
    t.bigint "location_id"
    t.index ["location_id"], name: "index_locations_plans_on_location_id"
    t.index ["plan_id"], name: "index_locations_plans_on_plan_id"
  end

  create_table "member_feedbacks", force: :cascade do |t|
    t.boolean "anonymous", default: false, null: false
    t.text "comment"
    t.integer "rating"
    t.integer "operator_id", null: false
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "office_leases", force: :cascade do |t|
    t.bigint "operator_id", null: false
    t.bigint "organization_id", null: false
    t.bigint "office_id", null: false
    t.date "start_date", null: false
    t.date "end_date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "subscription_id"
    t.date "initial_invoice_date"
    t.boolean "always_allow_building_access", default: true, null: false
    t.bigint "location_id"
    t.index ["location_id"], name: "index_office_leases_on_location_id"
    t.index ["office_id"], name: "index_office_leases_on_office_id"
    t.index ["operator_id"], name: "index_office_leases_on_operator_id"
    t.index ["organization_id"], name: "index_office_leases_on_organization_id"
    t.index ["subscription_id"], name: "index_office_leases_on_subscription_id"
  end

  create_table "offices", force: :cascade do |t|
    t.bigint "operator_id", null: false
    t.string "name"
    t.string "slug"
    t.integer "capacity", default: 1, null: false
    t.boolean "visible", default: true, null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "location_id"
    t.integer "square_footage", default: 0, null: false
    t.index ["location_id"], name: "index_offices_on_location_id"
    t.index ["operator_id"], name: "index_offices_on_operator_id"
  end

  create_table "operator_surveys", force: :cascade do |t|
    t.integer "user_id"
    t.integer "operator_id"
    t.integer "square_footage"
    t.integer "number_of_members"
    t.string "space_name"
    t.string "operator_name"
    t.string "operator_email"
    t.string "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "operators", force: :cascade do |t|
    t.string "name", null: false
    t.string "subdomain", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "snippet", default: "Generic snippet about the space", null: false
    t.string "wifi_name", default: "not set", null: false
    t.string "wifi_password", default: "not set", null: false
    t.string "building_address", default: "not set", null: false
    t.boolean "approval_required", default: true, null: false
    t.string "contact_name"
    t.string "contact_email"
    t.string "contact_phone"
    t.integer "day_pass_cost_in_cents", default: 2500, null: false
    t.integer "square_footage", default: 0, null: false
    t.boolean "email_enabled", default: false, null: false
    t.string "kisi_api_key"
    t.string "stripe_user_id"
    t.string "stripe_publishable_key"
    t.string "stripe_refresh_token"
    t.string "stripe_access_token"
    t.string "billing_state", default: "demo", null: false
    t.string "ios_url"
    t.string "android_url"
    t.boolean "checkin_required", default: false, null: false
    t.string "membership_text"
    t.boolean "skip_onboarding", default: false, null: false
    t.boolean "announcements_enabled", default: true, null: false
    t.boolean "events_enabled", default: true, null: false
    t.boolean "door_integration_enabled", default: true, null: false
    t.boolean "rooms_enabled", default: true, null: false
    t.boolean "offices_enabled", default: true, null: false
    t.boolean "reservation_notifications", default: false, null: false
    t.boolean "membership_notifications", default: true, null: false
    t.boolean "signup_notifications", default: false, null: false
    t.boolean "day_pass_notifications", default: true, null: false
    t.boolean "member_feedback_notifications", default: true, null: false
    t.boolean "checkin_notifications", default: true, null: false
    t.boolean "refund_notifications", default: true, null: false
    t.boolean "post_notifications", default: true, null: false
    t.boolean "credits_enabled", default: false, null: false
    t.boolean "childcare_enabled", default: false, null: false
    t.boolean "bulletin_board_enabled", default: false, null: false
    t.string "android_server_key"
    t.boolean "crm_enabled", default: false, null: false
    t.index ["subdomain"], name: "index_operators_on_subdomain", unique: true
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name", null: false
    t.integer "owner_id"
    t.string "website"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "operator_id", default: 1, null: false
    t.string "stripe_customer_id"
    t.boolean "out_of_band", default: true, null: false
    t.index ["operator_id"], name: "index_organizations_on_operator_id"
  end

  create_table "plans", force: :cascade do |t|
    t.string "interval", null: false
    t.integer "amount_in_cents", null: false
    t.string "name", null: false
    t.boolean "visible", default: true, null: false
    t.boolean "available", default: true, null: false
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "stripe_plan_id"
    t.integer "operator_id", default: 1, null: false
    t.string "plan_type"
    t.boolean "always_allow_building_access", default: true, null: false
    t.boolean "has_day_limit", default: false, null: false
    t.integer "day_limit", default: 0, null: false
    t.integer "credits", default: 0, null: false
    t.integer "commitment_interval"
    t.integer "childcare_reservations", default: 0, null: false
    t.index ["operator_id"], name: "index_plans_on_operator_id"
  end

  create_table "post_replies", force: :cascade do |t|
    t.integer "post_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "posts", force: :cascade do |t|
    t.integer "location_id", null: false
    t.integer "user_id", null: false
    t.string "title", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "refunds", force: :cascade do |t|
    t.bigint "invoice_id"
    t.string "stripe_refund_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "amount", default: 0, null: false
    t.index ["invoice_id"], name: "index_refunds_on_invoice_id"
  end

  create_table "reservations", force: :cascade do |t|
    t.integer "user_id", null: false
    t.datetime "datetime_in", null: false
    t.integer "hours", default: 1, null: false
    t.integer "room_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "cancelled", default: false, null: false
    t.integer "minutes", default: 0, null: false
    t.integer "credit_cost", default: 0, null: false
  end

  create_table "rooms", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.boolean "whiteboard", default: false, null: false
    t.boolean "av", default: false, null: false
    t.integer "capacity", default: 1, null: false
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "visible", default: true, null: false
    t.integer "operator_id", default: 1, null: false
    t.bigint "location_id"
    t.integer "square_footage", default: 0, null: false
    t.boolean "rentable", default: false, null: false
    t.integer "hourly_rate_in_cents", default: 0, null: false
    t.integer "credit_cost", default: 0, null: false
    t.index ["location_id"], name: "index_rooms_on_location_id"
    t.index ["operator_id"], name: "index_rooms_on_operator_id"
  end

  create_table "rsvps", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "event_id", null: false
    t.boolean "going", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "ahoy_visit_id"
  end

  create_table "subdomains", force: :cascade do |t|
    t.string "subdomain", null: false
    t.boolean "in_use", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subscriptions", force: :cascade do |t|
    t.integer "plan_id", null: false
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "stripe_subscription_id"
    t.string "subscribable_type"
    t.bigint "subscribable_id"
    t.boolean "pending", default: false, null: false
    t.string "billable_type"
    t.bigint "billable_id"
    t.date "start_date", null: false
    t.index ["billable_type", "billable_id"], name: "index_subscriptions_on_billable_type_and_billable_id"
    t.index ["subscribable_type", "subscribable_id"], name: "index_subscriptions_on_subscribable_type_and_subscribable_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email", null: false
    t.string "password_digest"
    t.boolean "admin", default: false, null: false
    t.string "remember_digest"
    t.string "slug"
    t.text "bio"
    t.string "linkedin"
    t.string "twitter"
    t.string "website"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "organization_id"
    t.boolean "approved", default: false, null: false
    t.string "stripe_customer_id"
    t.integer "operator_id", default: 2, null: false
    t.boolean "superadmin", default: false, null: false
    t.boolean "out_of_band", default: false, null: false
    t.string "ios_token"
    t.string "reset_digest"
    t.datetime "reset_sent_at"
    t.boolean "card_added", default: false, null: false
    t.boolean "always_allow_building_access", default: false, null: false
    t.boolean "bill_to_organization", default: false, null: false
    t.boolean "archived", default: false, null: false
    t.string "phone"
    t.integer "credit_balance", default: 0, null: false
    t.integer "childcare_reservation_balance", default: 0, null: false
    t.string "android_token"
    t.index ["operator_id"], name: "index_users_on_operator_id"
  end

  create_table "weekly_updates", force: :cascade do |t|
    t.integer "operator_id"
    t.jsonb "blob"
    t.datetime "week_start"
    t.datetime "week_end"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "previous_blob"
  end

  add_foreign_key "doors", "locations"
  add_foreign_key "locations", "operators"
  add_foreign_key "office_leases", "locations"
  add_foreign_key "office_leases", "offices"
  add_foreign_key "office_leases", "operators"
  add_foreign_key "office_leases", "organizations"
  add_foreign_key "office_leases", "subscriptions"
  add_foreign_key "offices", "locations"
  add_foreign_key "offices", "operators"
  add_foreign_key "refunds", "invoices"
  add_foreign_key "rooms", "locations"
end
