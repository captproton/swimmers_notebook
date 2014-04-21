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

ActiveRecord::Schema.define(version: 20140413150202) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "efforts", force: true do |t|
    t.string   "name"
    t.string   "age"
    t.datetime "pubdate"
  end

  create_table "events", force: true do |t|
    t.string   "title"
    t.text     "results_url"
    t.text     "raw_text"
    t.json     "json_data",    default: {}, null: false
    t.integer  "swim_meet_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "pubdate"
  end

  create_table "swim_meets", force: true do |t|
    t.string   "title"
    t.datetime "started_on"
    t.datetime "finished_on"
    t.string   "courses"
    t.string   "location"
    t.text     "location_url"
    t.text     "results_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
