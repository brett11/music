class SetUpDatabase < ActiveRecord::Migration[5.0]
  def self.up
    create_table "albums", unsigned: true, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
      t.string "name",         limit: 100
      t.date   "release_date"
    end

    create_table "albums_artists", primary_key: ["album_id", "artist_id"], options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
      t.integer "album_id",  null: false, unsigned: true
      t.integer "artist_id", null: false, unsigned: true
      t.index ["album_id"], name: "FK_Album_idx", using: :btree
      t.index ["artist_id"], name: "FK_Artist_idx", using: :btree
    end

    create_table "artists", unsigned: true, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
      t.string "name_first", limit: 45
      t.string "name_last",  limit: 45
      t.string "name_stage", limit: 45, null: false
      t.index ["id"], name: "id_Artists_UNIQUE", unique: true, using: :btree
    end

    create_table "artists_concerts", primary_key: ["artist_id", "concert_id"], options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
      t.integer "artist_id",  null: false, unsigned: true
      t.integer "concert_id", null: false, unsigned: true
      t.index ["artist_id"], name: "FK_Artist_idx", using: :btree
      t.index ["concert_id"], name: "FK_Concert_idx", using: :btree
    end

    create_table "artists_users", primary_key: ["user_id", "artist_id"], options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
      t.integer "user_id",   null: false, unsigned: true
      t.integer "artist_id", null: false, unsigned: true
      t.index ["artist_id"], name: "FK_artist_id_idx", using: :btree
      t.index ["user_id"], name: "FK_user_id_idx", using: :btree
    end

    create_table "cities", unsigned: true, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
      t.string  "name",       limit: 45
      t.integer "state_id",                                                     unsigned: true
      t.integer "country_id",                                      null: false, unsigned: true
      t.decimal "latitude",              precision: 15, scale: 12
      t.decimal "longitude",             precision: 15, scale: 12
      t.index ["country_id"], name: "FK_Countries_id_idx", using: :btree
      t.index ["id"], name: "id_Cities_UNIQUE", unique: true, using: :btree
      t.index ["state_id"], name: "FK_States_id_idx", using: :btree
    end

    create_table "concerts", unsigned: true, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
      t.datetime "dateAndTime", null: false
      t.integer  "venue_id",    null: false, unsigned: true
      t.index ["id"], name: "id_Concerts_UNIQUE", unique: true, using: :btree
      t.index ["venue_id"], name: "FK_Venues_id_idx", using: :btree
    end

    create_table "countries", unsigned: true, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
      t.string "name", limit: 45, null: false
      t.index ["id"], name: "id_Country_UNIQUE", unique: true, using: :btree
    end

    create_table "songs", unsigned: true, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
      t.integer "album_id", unsigned: true
      t.index ["album_id"], name: "FK_Album_idx", using: :btree
      t.index ["id"], name: "id_Song_UNIQUE", unique: true, using: :btree
    end

    create_table "states", unsigned: true, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
      t.string "name",         limit: 45, null: false
      t.string "abbreviation", limit: 2,  null: false
      t.index ["id"], name: "id_States_UNIQUE", unique: true, using: :btree
    end

    create_table "users", unsigned: true, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
      t.string   "name_first",        limit: 45,              null: false
      t.string   "name_last",         limit: 45,              null: false
      t.string   "email",             limit: 100,             null: false
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "password_digest",   limit: 250,             null: false
      t.string   "remember_digest",   limit: 250
      t.string   "activation_digest", limit: 250
      t.integer  "activated",         limit: 1,   default: 0, null: false, unsigned: true
      t.datetime "activated_at"
      t.string   "reset_digest",      limit: 250
      t.datetime "reset_sent_at"
      t.integer  "admin",             limit: 1,   default: 0, null: false, unsigned: true
      t.index ["email"], name: "IX_Users_Email", unique: true, using: :btree
      t.index ["id"], name: "UQ_Users", unique: true, using: :btree
    end

    create_table "venues", unsigned: true, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
      t.string  "name",    limit: 60
      t.integer "city_id",            unsigned: true
      t.index ["city_id"], name: "FK_Cities_id_idx", using: :btree
      t.index ["id"], name: "id_Venue_UNIQUE", unique: true, using: :btree
    end

    add_foreign_key "albums_artists", "albums", name: "FK_Album_"
    add_foreign_key "albums_artists", "artists", name: "FK_Artist_"
    add_foreign_key "artists_concerts", "artists", name: "FK_Artist", on_update: :cascade, on_delete: :cascade
    add_foreign_key "artists_concerts", "concerts", name: "FK_Concert", on_update: :cascade, on_delete: :cascade
    add_foreign_key "artists_users", "artists", name: "FK_Artist_id"
    add_foreign_key "artists_users", "users", name: "FK_User_id"
    add_foreign_key "cities", "countries", name: "FK_Countries_id"
    add_foreign_key "cities", "states", name: "FK_States_id"
    add_foreign_key "concerts", "venues", name: "FK_Venues_id"
    add_foreign_key "songs", "albums", name: "FK_Album", on_update: :cascade, on_delete: :cascade
    add_foreign_key "venues", "cities", name: "FK_Cities_id", on_update: :cascade
  end

  def self.down
    drop_table :countries
    drop_table :states
    drop_table :cities
    drop_table :venues
    drop_table :concerts
    drop_table :artists
    drop_table :artists_concerts
    drop_table :users
    drop_table :artists_users
    drop_table :albums
    drop_table :albums_artists
    drop_table :songs

  end
end
