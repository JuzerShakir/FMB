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

ActiveRecord::Schema[8.0].define(version: 2024_12_20_050110) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "apartments", ["Mohammedi", "Taiyebi", "Burhani", "Maimoon A", "Maimoon B"]
  create_enum "modes", ["Cash", "Cheque", "Bank"]
  create_enum "sizes", ["Small", "Medium", "Large"]

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource"
  end

  create_table "sabeels", force: :cascade do |t|
    t.integer "its", null: false
    t.string "name", null: false
    t.integer "flat_no", null: false
    t.bigint "mobile", null: false
    t.string "email"
    t.string "slug", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.enum "apartment", default: "Mohammedi", null: false, enum_type: "apartments"
    t.index ["its"], name: "index_sabeels_on_its", unique: true
    t.index ["slug"], name: "index_sabeels_on_slug", unique: true
  end

  create_table "sessions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "thaalis", force: :cascade do |t|
    t.bigint "sabeel_id", null: false
    t.integer "year", null: false
    t.integer "total", null: false
    t.integer "number", null: false
    t.string "slug", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.enum "size", default: "Small", null: false, enum_type: "sizes"
    t.index ["sabeel_id"], name: "index_thaalis_on_sabeel_id"
    t.index ["slug"], name: "index_thaalis_on_slug", unique: true
    t.index ["year", "sabeel_id"], name: "index_thaalis_on_year_and_sabeel_id", unique: true
  end

  create_table "transactions", force: :cascade do |t|
    t.bigint "thaali_id", null: false
    t.integer "receipt_number", null: false
    t.integer "amount", null: false
    t.date "date", null: false
    t.string "slug", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.enum "mode", default: "Cash", null: false, enum_type: "modes"
    t.index ["receipt_number"], name: "index_transactions_on_receipt_number", unique: true
    t.index ["slug"], name: "index_transactions_on_slug", unique: true
    t.index ["thaali_id"], name: "index_transactions_on_thaali_id"
  end

  create_table "users", force: :cascade do |t|
    t.integer "its", null: false
    t.string "name", null: false
    t.string "password_digest", null: false
    t.string "slug", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["its"], name: "index_users_on_its", unique: true
    t.index ["slug"], name: "index_users_on_slug", unique: true
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "role_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  add_foreign_key "sessions", "users"
  add_foreign_key "thaalis", "sabeels"
  add_foreign_key "transactions", "thaalis"
end
