# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20081028032441) do

  create_table "activities", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description"
    t.integer  "position"
    t.string   "alt_text"
  end

  create_table "blacklisted_sites", :force => true do |t|
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "blacklisted_sites", ["url"], :name => "index_blacklisted_sites_on_url"

  create_table "comments", :force => true do |t|
    t.string   "title",            :limit => 50, :default => ""
    t.string   "comment",                        :default => ""
    t.datetime "created_at",                                     :null => false
    t.integer  "commentable_id",                 :default => 0,  :null => false
    t.string   "commentable_type", :limit => 15, :default => "", :null => false
    t.integer  "user_id",                        :default => 0,  :null => false
  end

  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "countries", :force => true do |t|
    t.string   "name"
    t.string   "code",       :limit => 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "domains", :force => true do |t|
    t.string   "url"
    t.string   "phrase"
    t.string   "link_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "key_phrases", :force => true do |t|
    t.string   "phrase"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "site_id"
    t.boolean  "preferred",         :default => false
    t.boolean  "paid",              :default => false
    t.string   "label"
    t.string   "link_name"
    t.boolean  "linkable"
    t.integer  "domain_id"
    t.string   "advertisement_url"
    t.string   "ad_context"
  end

  add_index "key_phrases", ["site_id"], :name => "index_key_phrases_on_site_id"
  add_index "key_phrases", ["link_name"], :name => "index_key_phrases_on_link_name"

  create_table "metro_service_area_links", :force => true do |t|
    t.integer  "metro_service_area_id"
    t.string   "name"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "metro_service_areas", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "link_name"
    t.integer  "homepage"
    t.integer  "domain_id"
    t.integer  "parent_id"
    t.string   "flash_filename"
  end

  add_index "metro_service_areas", ["link_name"], :name => "index_metro_service_areas_on_link_name"

  create_table "people", :force => true do |t|
    t.integer  "personable_id"
    t.string   "personable_type"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "city"
    t.string   "country"
    t.string   "birth_year"
    t.string   "url"
    t.text     "description"
    t.boolean  "agreed_to_terms"
  end

  add_index "people", ["personable_id", "personable_type"], :name => "index_people_on_personable_id_and_personable_type"

  create_table "sites", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.string   "state"
    t.string   "city"
    t.boolean  "free"
    t.boolean  "registration_required"
    t.text     "description"
    t.boolean  "official"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country_code"
    t.integer  "topic_id"
    t.integer  "activity_id"
    t.integer  "metro_service_area_id"
    t.boolean  "disabled"
    t.integer  "user_id"
    t.boolean  "ad_only"
    t.boolean  "restrict_to_msa"
    t.boolean  "online",                :default => false
    t.boolean  "all_msas",              :default => false
  end

  add_index "sites", ["topic_id"], :name => "index_sites_on_topic_id"
  add_index "sites", ["metro_service_area_id"], :name => "index_sites_on_metro_service_area_id"
  add_index "sites", ["url"], :name => "index_sites_on_url"

  create_table "states", :force => true do |t|
    t.string "code",      :limit => 2
    t.string "name",      :limit => 35
    t.string "link_name"
  end

  add_index "states", ["code"], :name => "index_states_on_code"

  create_table "topics", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "root_id"
    t.string   "link_name"
    t.integer  "domain_id"
  end

  add_index "topics", ["link_name"], :name => "index_topics_on_link_name"
  add_index "topics", ["lft"], :name => "index_topics_on_lft"
  add_index "topics", ["rgt"], :name => "index_topics_on_rgt"
  add_index "topics", ["root_id"], :name => "index_topics_on_root_id"

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "open_id_url"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
    t.string   "password_reset_code",       :limit => 40
    t.datetime "password_reset_at"
    t.boolean  "active",                                  :default => true
    t.boolean  "admin",                                   :default => false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ub_alias"
    t.string   "ub_override"
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["open_id_url"], :name => "index_users_on_open_id_url"

end
