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

ActiveRecord::Schema.define(version: 20170629125231) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_trgm"
  enable_extension "unaccent"

  create_table "albums", id: :bigserial, force: :cascade do |t|
    t.string   "name",                     limit: 100
    t.date     "release_date"
    t.string   "album_cover_file_name",    limit: 255
    t.string   "album_cover_content_type", limit: 255
    t.bigint   "album_cover_file_size"
    t.datetime "album_cover_updated_at"
  end

  create_table "albums_artists", id: false, force: :cascade do |t|
    t.bigint "album_id",  null: false
    t.bigint "artist_id", null: false
    t.index ["album_id", "artist_id"], name: "idx_24820_index_albums_artists_on_album_id_and_artist_id", unique: true, using: :btree
    t.index ["album_id"], name: "idx_24820_fk_album_idx", using: :btree
    t.index ["artist_id"], name: "idx_24820_fk_artist_idx", using: :btree
  end

  create_table "artists", id: :bigserial, force: :cascade do |t|
    t.string   "name_first",          limit: 45
    t.string   "name_last",           limit: 45
    t.string   "name_stage",          limit: 45,  null: false
    t.string   "avatar_file_name",    limit: 255
    t.string   "avatar_content_type", limit: 255
    t.bigint   "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.index ["id"], name: "idx_24825_id_artists_unique", unique: true, using: :btree
  end

  create_table "artists_concerts", id: false, force: :cascade do |t|
    t.bigint "artist_id",  null: false
    t.bigint "concert_id", null: false
    t.index ["artist_id", "concert_id"], name: "idx_24832_index_artists_concerts_on_artist_id_and_concert_id", unique: true, using: :btree
    t.index ["artist_id"], name: "idx_24832_fk_artist_idx", using: :btree
    t.index ["concert_id"], name: "idx_24832_fk_concert_idx", using: :btree
  end

  create_table "artists_users", id: false, force: :cascade do |t|
    t.bigint "user_id",   null: false
    t.bigint "artist_id", null: false
    t.index ["artist_id", "user_id"], name: "idx_24835_index_artists_users_on_artist_id_and_user_id", unique: true, using: :btree
    t.index ["artist_id"], name: "idx_24835_fk_artist_id_idx", using: :btree
    t.index ["user_id"], name: "idx_24835_fk_user_id_idx", using: :btree
  end

  create_table "cities", id: :bigserial, force: :cascade do |t|
    t.string  "name",       limit: 45
    t.bigint  "state_id"
    t.bigint  "country_id",                                      null: false
    t.decimal "latitude",              precision: 15, scale: 12
    t.decimal "longitude",             precision: 15, scale: 12
    t.index ["country_id"], name: "idx_24846_fk_countries_id_idx", using: :btree
    t.index ["id"], name: "idx_24846_id_cities_unique", unique: true, using: :btree
    t.index ["state_id"], name: "idx_24846_fk_states_id_idx", using: :btree
  end

  create_table "concerts", id: :bigserial, force: :cascade do |t|
    t.datetime "dateandtime", null: false
    t.bigint   "venue_id",    null: false
    t.index ["id"], name: "idx_24852_id_concerts_unique", unique: true, using: :btree
    t.index ["venue_id"], name: "idx_24852_fk_venues_id_idx", using: :btree
  end

  create_table "countries", id: :bigserial, force: :cascade do |t|
    t.string "name", limit: 45, null: false
    t.index ["id"], name: "idx_24858_id_country_unique", unique: true, using: :btree
  end

  create_table "songs", id: :bigserial, force: :cascade do |t|
    t.bigint "album_id"
    t.string "name",     limit: 255
    t.index ["album_id"], name: "idx_24867_fk_album_idx", using: :btree
    t.index ["id"], name: "idx_24867_id_song_unique", unique: true, using: :btree
  end

  create_table "states", id: :bigserial, force: :cascade do |t|
    t.string "name",         limit: 45, null: false
    t.string "abbreviation", limit: 2,  null: false
    t.index ["id"], name: "idx_24873_id_states_unique", unique: true, using: :btree
  end

  create_table "users", id: :bigserial, force: :cascade do |t|
    t.string   "name_first",               limit: 45,              null: false
    t.string   "name_last",                limit: 45,              null: false
    t.string   "email",                    limit: 100,             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest",          limit: 250,             null: false
    t.string   "remember_digest",          limit: 250
    t.string   "activation_digest",        limit: 250
    t.integer  "activated",                limit: 2,   default: 0, null: false
    t.datetime "activated_at"
    t.string   "reset_digest",             limit: 250
    t.datetime "reset_sent_at"
    t.integer  "admin",                    limit: 2,   default: 0, null: false
    t.string   "profile_pic_file_name",    limit: 255
    t.string   "profile_pic_content_type", limit: 255
    t.bigint   "profile_pic_file_size"
    t.datetime "profile_pic_updated_at"
    t.index ["email"], name: "idx_24879_ix_users_email", unique: true, using: :btree
    t.index ["id"], name: "idx_24879_uq_users", unique: true, using: :btree
  end

  create_table "venues", id: :bigserial, force: :cascade do |t|
    t.string "name",    limit: 60
    t.bigint "city_id"
    t.index ["city_id"], name: "idx_24890_fk_cities_id_idx", using: :btree
    t.index ["id"], name: "idx_24890_id_venue_unique", unique: true, using: :btree
  end

  add_foreign_key "albums_artists", "albums", name: "fk_album_", on_update: :restrict, on_delete: :restrict
  add_foreign_key "albums_artists", "artists", name: "fk_artist_", on_update: :restrict, on_delete: :restrict
  add_foreign_key "artists_concerts", "artists", name: "fk_artist", on_update: :cascade, on_delete: :cascade
  add_foreign_key "artists_concerts", "concerts", name: "fk_concert", on_update: :cascade, on_delete: :cascade
  add_foreign_key "artists_users", "artists", name: "fk_artist_id", on_update: :restrict, on_delete: :restrict
  add_foreign_key "artists_users", "users", name: "fk_user_id", on_update: :restrict, on_delete: :restrict
  add_foreign_key "cities", "countries", name: "fk_countries_id", on_update: :restrict, on_delete: :restrict
  add_foreign_key "cities", "states", name: "fk_states_id", on_update: :restrict, on_delete: :restrict
  add_foreign_key "concerts", "venues", name: "fk_venues_id", on_update: :restrict, on_delete: :restrict
  add_foreign_key "songs", "albums", name: "fk_album", on_update: :cascade, on_delete: :cascade
  add_foreign_key "venues", "cities", name: "fk_cities_id", on_update: :cascade, on_delete: :restrict
end
