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

ActiveRecord::Schema.define(version: 20170106105042) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "attachments", force: :cascade do |t|
    t.string "file_name"
    t.string "file_size"
    t.string "file_type"
    t.string "attachment"
    t.text   "content"
  end

  create_table "comments", force: :cascade do |t|
    t.integer "status_id"
    t.text    "content"
    t.index ["status_id"], name: "index_comments_on_status_id", using: :btree
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree
  end

  create_table "ideas", force: :cascade do |t|
    t.text "content"
  end

  create_table "image_arrays", force: :cascade do |t|
    t.string "image_array", default: [], array: true
    t.string "file_names",  default: [], array: true
    t.string "file_sizes",  default: [], array: true
    t.string "file_types",  default: [], array: true
    t.text   "content"
  end

  create_table "notifications", force: :cascade do |t|
    t.integer  "user_id",     null: false
    t.integer  "actor_id"
    t.datetime "read_at"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "notify_type"
    t.integer  "status_id"
    t.index ["status_id"], name: "index_notifications_on_status_id", using: :btree
    t.index ["user_id", "notify_type"], name: "index_notifications_on_user_id_and_notify_type", using: :btree
    t.index ["user_id"], name: "index_notifications_on_user_id", using: :btree
  end

  create_table "projects", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "desc"
    t.string   "avatar"
    t.string   "slug"
    t.index ["slug"], name: "index_projects_on_slug", unique: true, using: :btree
    t.index ["user_id"], name: "index_projects_on_user_id", using: :btree
  end

  create_table "publications", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.text     "content_html"
    t.integer  "publishable_id"
    t.string   "publishable_type"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["project_id"], name: "index_publications_on_project_id", using: :btree
    t.index ["publishable_id", "publishable_type"], name: "index_publications_on_publishable_id_and_publishable_type", using: :btree
    t.index ["user_id"], name: "index_publications_on_user_id", using: :btree
  end

  create_table "relations", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "action_type"
    t.string   "relationable_type"
    t.integer  "relationable_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["action_type"], name: "index_relations_on_action_type", using: :btree
    t.index ["relationable_type", "relationable_id"], name: "index_relations_on_relationable_type_and_relationable_id", using: :btree
    t.index ["user_id"], name: "index_relations_on_user_id", using: :btree
  end

  create_table "settings", force: :cascade do |t|
    t.string   "var",                   null: false
    t.text     "value"
    t.integer  "thing_id"
    t.string   "thing_type", limit: 30
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["thing_type", "thing_id", "var"], name: "index_settings_on_thing_type_and_thing_id_and_var", unique: true, using: :btree
  end

  create_table "statuses", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.integer  "action_type"
    t.text     "content"
    t.integer  "statusable_id"
    t.string   "statusable_type"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["project_id"], name: "index_statuses_on_project_id", using: :btree
    t.index ["statusable_id", "statusable_type"], name: "index_statuses_on_statusable_id_and_statusable_type", using: :btree
    t.index ["statusable_type"], name: "index_statuses_on_statusable_type", using: :btree
    t.index ["user_id"], name: "index_statuses_on_user_id", using: :btree
  end

  create_table "user_profiles", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "avatar"
    t.string   "homepage"
    t.string   "location"
    t.integer  "gender",            default: 0
    t.date     "birthday"
    t.text     "description"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "domain"
    t.datetime "domain_updated_at"
    t.datetime "name_updated_at"
    t.index ["domain"], name: "index_user_profiles_on_domain", unique: true, using: :btree
    t.index ["name"], name: "index_user_profiles_on_name", unique: true, using: :btree
    t.index ["user_id"], name: "index_user_profiles_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.datetime "last_seen"
    t.integer  "role",                   default: 0
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "publications", "projects"
  add_foreign_key "publications", "users"
  add_foreign_key "user_profiles", "users"
end
