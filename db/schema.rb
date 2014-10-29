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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20141029154438) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "oauth_token"
    t.string   "login"
    t.datetime "oauth_expires_at"
    t.string   "email"
    t.string   "password_digest"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.string   "picture"
    t.datetime "date_added"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", force: true do |t|
    t.string   "title"
    t.string   "content"
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "event_type"
  end

  create_table "events_timelines", id: false, force: true do |t|
    t.integer "event_id"
    t.integer "timeline_id"
  end

  create_table "repo_events", force: true do |t|
    t.string   "repository"
    t.string   "author"
    t.string   "activity_type"
    t.string   "html_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "event_id"
  end

  create_table "timelines", force: true do |t|
    t.string   "title"
    t.string   "content"
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "timelines_timelines", id: false, force: true do |t|
    t.integer "parent_id"
    t.integer "child_id"
  end

  create_table "users", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_foreign_key "accounts", "users", name: "accounts_user_id_fk", dependent: :delete

  add_foreign_key "events", "users", name: "event_user_foreign_key", dependent: :delete

  add_foreign_key "timelines", "users", name: "timeline_user_foreign_key", dependent: :delete

end
