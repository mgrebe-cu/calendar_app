# encoding: UTF-8
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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130317000327) do

  create_table "calendars", :force => true do |t|
    t.boolean  "default"
    t.integer  "user_id"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "title",       :default => "Default"
    t.text     "description"
    t.integer  "color",       :default => 0
    t.boolean  "displayed",   :default => true
    t.boolean  "public",      :default => false
  end

  add_index "calendars", ["user_id"], :name => "index_calendars_on_user_id"

  create_table "events", :force => true do |t|
    t.integer  "calendar_id"
    t.boolean  "all_day"
    t.datetime "start_time"
    t.datetime "end_time"
    t.string   "location"
    t.text     "notes"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "title"
    t.date     "start_date"
    t.date     "end_date"
  end

  add_index "events", ["calendar_id"], :name => "index_events_on_calendar_id"
  add_index "events", ["start_time", "end_time"], :name => "index_events_on_start_time_and_end_time"

  create_table "subscriptions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "calendar_id"
    t.boolean  "subscribed",  :default => false
    t.integer  "color",       :default => 0
    t.boolean  "rw",          :default => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.boolean  "displayed",   :default => true
    t.string   "title"
  end

  add_index "subscriptions", ["calendar_id"], :name => "index_subscriptions_on_calendar_id"
  add_index "subscriptions", ["user_id", "calendar_id"], :name => "index_subscriptions_on_user_id_and_calendar_id", :unique => true
  add_index "subscriptions", ["user_id"], :name => "index_subscriptions_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "full_name"
    t.string   "username"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "password_digest"
    t.integer  "default_view",    :default => 0
    t.string   "time_zone"
    t.boolean  "admin",           :default => false
  end

  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

end
