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

ActiveRecord::Schema.define(version: 20160201074819) do

  create_table "devices", force: :cascade do |t|
    t.string   "uid"
    t.datetime "next_timeout"
  end

  create_table "humidifiers", force: :cascade do |t|
    t.float    "min_humidity",   default: 36.0
    t.integer  "max_shots",      default: 6
    t.integer  "shot_duration",  default: 30
    t.integer  "shot_left",      default: 6
    t.integer  "sleep_duration", default: 10
    t.integer  "start_command",                        null: false
    t.integer  "stop_command",                         null: false
    t.datetime "next_tick_at"
    t.string   "state",          default: "check_env"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "measurements", force: :cascade do |t|
    t.float    "temperature", null: false
    t.float    "humidity",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "measurements", ["created_at"], name: "index_measurements_on_created_at"

end
