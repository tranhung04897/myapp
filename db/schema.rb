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

ActiveRecord::Schema[7.0].define(version: 2023_03_23_101841) do
  create_table "order_infomations", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.date "issue_date"
    t.date "flt_date"
    t.string "ticket_number", null: false
    t.string "pax_name"
    t.string "route"
    t.string "type_ticket"
    t.string "pnr"
    t.string "coupon_status"
    t.string "class_ticket"
    t.string "ag"
    t.string "osi_ca", default: ""
    t.string "osi_booker", default: ""
    t.bigint "fare"
    t.bigint "charge"
    t.bigint "nat_amt"
    t.string "saler"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ticket_number", "type_ticket"], name: "index_order_infomations_on_ticket_number_and_type_ticket", unique: true
  end

  create_table "osi_bookers", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.string "syntax_osi"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "limit_value", default: 0
  end

  create_table "osi_cas", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.string "syntax_osi"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "limit_value", default: 0
  end

  create_table "roles", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "email", default: ""
    t.string "name", default: ""
    t.string "username", default: "", null: false, comment: "User name"
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "role_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role_id"], name: "index_users_on_role_id"
  end

end
