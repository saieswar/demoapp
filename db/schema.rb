# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20171002110316) do

  create_table "addresses", force: :cascade do |t|
    t.string   "address1"
    t.string   "address2"
    t.integer  "zip_id"
    t.string   "addressable_type"
    t.integer  "addressable_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "agents", force: :cascade do |t|
    t.string   "real_estate_licensee", limit: 255
    t.string   "agency_name",          limit: 255
    t.text     "brief_profile",        limit: 65535
    t.integer  "user_id",              limit: 4
    t.float    "rating",               limit: 24
    t.string   "bio_status",           limit: 255
    t.text     "message",              limit: 65535
    t.text     "temp_bio",             limit: 65535
    t.string   "profile_status",       limit: 255
    t.string   "temp_licence",         limit: 255
    t.text     "reject_notes",         limit: 65535
    t.integer  "transactions",         limit: 4
    t.float    "experience",           limit: 24
    t.text     "languages",            limit: 65535
    t.string   "job_title",            limit: 255
    t.string   "office",               limit: 255
    t.string   "home_page",            limit: 255
    t.float    "progress_status",      limit: 24,    default: 0.0
    t.datetime "deleted_at"
    t.string   "license_state",        limit: 255
    t.string   "zohu_crm_id",          limit: 255
    t.string   "primary_market",       limit: 255
    t.string   "secondary_market",     limit: 255
    t.boolean  "contacted",            limit: 1,     default: false
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
  end

  create_table "bids", force: :cascade do |t|
    t.float    "bid_percentage"
    t.integer  "est_asking_price"
    t.integer  "property_id"
    t.integer  "bid_status_id"
    t.integer  "agent_id"
    t.boolean  "sent_to_owner"
    t.date     "bid_end_date"
    t.boolean  "is_open"
    t.text     "message"
    t.datetime "bid_accepted_at"
    t.float    "buyer_percentage"
    t.string   "notification_sent"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "properties", force: :cascade do |t|
    t.integer  "seller_id"
    t.integer  "property_type_id"
    t.integer  "structure_size"
    t.integer  "bedrooms"
    t.float    "bathrooms"
    t.integer  "basement_type_id"
    t.float    "lot_size"
    t.integer  "year_built"
    t.integer  "est_sale_price"
    t.string   "listing_type"
    t.string   "status"
    t.integer  "response_count"
    t.boolean  "active",               default: true
    t.date     "list_end_date"
    t.boolean  "garage"
    t.boolean  "pool"
    t.boolean  "water_front"
    t.string   "garage_doors"
    t.string   "lot_size_units"
    t.boolean  "buy_another_property", default: false
    t.string   "reject_notes"
    t.text     "additional_note"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  create_table "property_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "propery_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sellers", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.integer  "role_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "full_name"
    t.string   "phone"
    t.string   "device_id"
    t.string   "token"
    t.string   "device_type"
    t.string   "auth_token"
    t.string   "otp_secret_key"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "zips", force: :cascade do |t|
    t.integer  "zip_code"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
