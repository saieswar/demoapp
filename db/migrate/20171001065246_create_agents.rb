class CreateAgents < ActiveRecord::Migration[5.0]
  def change
    create_table :agents do |t|
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
    t.timestamps
    end
  end
end
