# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_02_01_222312) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "experiences", force: :cascade do |t|
    t.string "company", null: false
    t.string "office", null: false
    t.string "description", null: false
    t.date "start_date", null: false
    t.date "end_date"
    t.boolean "current_job", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "profile_id", null: false
    t.index ["profile_id"], name: "index_experiences_on_profile_id"
  end

  create_table "formations", force: :cascade do |t|
    t.string "university"
    t.date "conclusion"
    t.date "start"
    t.boolean "status", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "profile_id", null: false
    t.index ["profile_id"], name: "index_formations_on_profile_id"
  end

  create_table "professionals", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_professionals_on_email", unique: true
    t.index ["reset_password_token"], name: "index_professionals_on_reset_password_token", unique: true
  end

  create_table "profiles", force: :cascade do |t|
    t.string "name"
    t.string "social_name"
    t.text "description"
    t.date "birth_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "professional_id", null: false
    t.integer "age"
    t.integer "gender", default: 0
    t.index ["professional_id"], name: "index_profiles_on_professional_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.date "deadline_submission"
    t.bigint "user_id", null: false
    t.boolean "remote", default: false
    t.decimal "max_price_per_hour"
    t.integer "status", default: 0
    t.index ["user_id"], name: "index_projects_on_user_id"
  end

  create_table "proposals", force: :cascade do |t|
    t.text "justification"
    t.decimal "price_hour"
    t.integer "weekly_hour"
    t.integer "completion_deadline"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "professional_id", null: false
    t.bigint "project_id", null: false
    t.integer "status", default: 0
    t.string "feedback"
    t.date "deadline_cancel"
    t.index ["professional_id"], name: "index_proposals_on_professional_id"
    t.index ["project_id"], name: "index_proposals_on_project_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "experiences", "profiles"
  add_foreign_key "formations", "profiles"
  add_foreign_key "profiles", "professionals"
  add_foreign_key "projects", "users"
  add_foreign_key "proposals", "professionals"
  add_foreign_key "proposals", "projects"
end
