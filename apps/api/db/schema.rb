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

ActiveRecord::Schema[8.1].define(version: 2025_11_09_160500) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.string "service_name"
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "etag"
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variants_uniqueness", unique: true
  end

  create_table "diary_entries", force: :cascade do |t|
    t.text "ai_summary"
    t.text "body"
    t.datetime "created_at", null: false
    t.text "extracted_text"
    t.date "journal_date", null: false
    t.jsonb "labels", default: []
    t.string "language", default: "ja"
    t.jsonb "metadata", default: {}
    t.string "mood"
    t.datetime "published_at"
    t.string "source_filename"
    t.string "status", default: "draft", null: false
    t.string "timezone", default: "Asia/Tokyo"
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["status"], name: "index_diary_entries_on_status"
    t.index ["user_id", "journal_date"], name: "index_diary_entries_on_user_id_and_journal_date"
    t.index ["user_id"], name: "index_diary_entries_on_user_id"
  end

  create_table "diary_entry_tags", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "diary_entry_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "updated_at", null: false
    t.index ["diary_entry_id", "tag_id"], name: "idx_diary_entry_tags_uniqueness", unique: true
    t.index ["diary_entry_id"], name: "index_diary_entry_tags_on_diary_entry_id"
    t.index ["tag_id"], name: "index_diary_entry_tags_on_tag_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "category"
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "avatar_url"
    t.datetime "confirmation_sent_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "name"
    t.string "nickname"
    t.jsonb "preferences", default: {}
    t.string "provider", default: "email", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.string "time_zone", default: "Asia/Tokyo"
    t.jsonb "tokens", default: {}
    t.string "uid", default: "", null: false
    t.string "unconfirmed_email"
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

  create_table "weekly_digests", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.jsonb "highlights", default: []
    t.jsonb "mood_trends", default: {}
    t.datetime "published_at"
    t.text "summary", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.date "week_of", null: false
    t.index ["user_id", "week_of"], name: "index_weekly_digests_on_user_id_and_week_of", unique: true
    t.index ["user_id"], name: "index_weekly_digests_on_user_id"
  end

  add_foreign_key "diary_entries", "users"
  add_foreign_key "diary_entry_tags", "diary_entries"
  add_foreign_key "diary_entry_tags", "tags"
  add_foreign_key "weekly_digests", "users"
end
