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

ActiveRecord::Schema.define(version: 20170917182135) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "reflections", id: :serial, force: :cascade do |t|
    t.integer "rating"
    t.text "wrong"
    t.text "right"
    t.text "undone"
    t.date "date"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_reflections_on_user_id"
  end

  create_table "todo_lists", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "list_type", default: "daily", null: false
    t.integer "week_plan_id"
    t.index ["user_id"], name: "index_todo_lists_on_user_id"
  end

  create_table "todos", id: :serial, force: :cascade do |t|
    t.string "content"
    t.boolean "complete", default: false
    t.integer "estimated_time_blocks", default: 0
    t.integer "actual_time_blocks", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "todo_list_id"
    t.index ["todo_list_id"], name: "index_todos_on_todo_list_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "phone"
    t.boolean "email_reminders", default: false
    t.boolean "sms_reminders", default: false
    t.boolean "track_weekends", default: true
    t.string "timezone"
    t.boolean "paid", default: false, null: false
    t.boolean "guest"
    t.string "google_id"
    t.string "stripe_charge_id"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "reflections", "users"
  add_foreign_key "todo_lists", "users"
  add_foreign_key "todos", "todo_lists"
end
