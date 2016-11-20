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

ActiveRecord::Schema.define(version: 20161118201735) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "events", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.string   "country"
    t.string   "city"
    t.string   "host"
    t.string   "url"
    t.string   "external_id"
    t.string   "external_updated_at"
    t.string   "utc_offset_fmt"
    t.integer  "utc_offset"
    t.datetime "starts_at"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "time_zone"
  end

  create_table "extracted_urls", force: :cascade do |t|
    t.string   "url",              null: false
    t.integer  "source_id"
    t.string   "source_type"
    t.integer  "canonical_url_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "extracted_urls", ["canonical_url_id"], name: "index_extracted_urls_on_canonical_url_id", using: :btree
  add_index "extracted_urls", ["source_type", "source_id"], name: "index_extracted_urls_on_source_type_and_source_id", using: :btree

  create_table "identities", force: :cascade do |t|
    t.string   "uid"
    t.string   "provider"
    t.string   "name"
    t.string   "email"
    t.string   "image"
    t.string   "nickname"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "description"
    t.string   "location"
    t.string   "phone"
    t.text     "raw"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "meetup_groups", force: :cascade do |t|
    t.text     "description"
    t.string   "name"
    t.string   "city"
    t.string   "country"
    t.string   "url"
    t.string   "external_id"
    t.string   "utc_offset_fmt"
    t.string   "time_zone"
    t.string   "state"
    t.string   "urlname"
    t.string   "photo_highres"
    t.string   "photo"
    t.string   "photo_thumb"
    t.integer  "member_count"
    t.integer  "utc_offset"
    t.datetime "external_created_at"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "tweets", force: :cascade do |t|
    t.string   "twitter_id",                 null: false
    t.jsonb    "raw",                        null: false
    t.boolean  "processed",  default: false, null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

end
