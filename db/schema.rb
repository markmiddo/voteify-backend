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

ActiveRecord::Schema.define(version: 2022_08_09_104431) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "about_us_details", force: :cascade do |t|
    t.string "subtitle"
    t.string "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "answers", force: :cascade do |t|
    t.string "answer_value"
    t.bigint "patron_id"
    t.bigint "question_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["patron_id"], name: "index_answers_on_patron_id"
    t.index ["question_id"], name: "index_answers_on_question_id"
  end

  create_table "event_track_votes", force: :cascade do |t|
    t.bigint "vote_id"
    t.bigint "event_track_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_top", default: false, null: false
    t.index ["event_track_id"], name: "index_event_track_votes_on_event_track_id"
    t.index ["vote_id"], name: "index_event_track_votes_on_vote_id"
  end

  create_table "event_tracks", force: :cascade do |t|
    t.bigint "event_id"
    t.bigint "track_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "patron_id"
    t.integer "event_track_votes_count", default: 0
    t.string "original_title"
    t.string "original_author"
    t.integer "duplication_points", default: 0
    t.index ["event_id", "track_id"], name: "index_event_tracks_on_event_id_and_track_id", unique: true
    t.index ["event_id"], name: "index_event_tracks_on_event_id"
    t.index ["patron_id"], name: "index_event_tracks_on_patron_id"
    t.index ["track_id"], name: "index_event_tracks_on_track_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "name"
    t.string "subtitle"
    t.datetime "start_date"
    t.datetime "end_date"
    t.string "place"
    t.text "description"
    t.string "ticket_url"
    t.string "fb_pixel"
    t.string "google_analytic"
    t.integer "track_count_for_vote"
    t.string "color"
    t.string "landing_image"
    t.string "sharing_image"
    t.string "csv_file"
    t.bigint "client_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "votes_count", default: 0
    t.integer "views_count", default: 0
    t.integer "sharing_count", default: 0
    t.string "facebook_title", null: false
    t.string "facebook_description", null: false
    t.string "event_url"
    t.string "share_title", null: false
    t.string "share_description", null: false
    t.string "top_songs_description", null: false
    t.string "square_image"
    t.integer "text_color", default: 0, null: false
    t.string "shortlist_description"
    t.datetime "vote_end_date", null: false
    t.integer "csv_processed_line_count", default: 0
    t.index ["client_id"], name: "index_events_on_client_id"
  end

  create_table "questions", force: :cascade do |t|
    t.string "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "terms_and_conditions", force: :cascade do |t|
    t.string "title"
    t.string "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tracks", force: :cascade do |t|
    t.string "title"
    t.string "author"
    t.string "video_id"
    t.string "thumbnails"
    t.string "youtube_title"
    t.text "youtube_description"
    t.datetime "published_at"
    t.index ["author"], name: "index_tracks_on_author"
    t.index ["title"], name: "index_tracks_on_title"
    t.index ["video_id"], name: "index_tracks_on_video_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.string "remember_token"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "name"
    t.string "avatar"
    t.string "email"
    t.string "fb_url"
    t.string "instagram_url"
    t.json "tokens"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type"
    t.string "company_name"
    t.boolean "allow_password_change", default: false, null: false
    t.index ["email", "provider"], name: "index_users_on_email_and_provider", unique: true
    t.index ["type"], name: "index_users_on_type"
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

  create_table "view_events", force: :cascade do |t|
    t.bigint "patron_id"
    t.bigint "event_id"
    t.string "visitor_uid"
    t.integer "page"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_view_events_on_event_id"
    t.index ["patron_id", "event_id", "visitor_uid", "page"], name: "view_events_index", unique: true
    t.index ["patron_id"], name: "index_view_events_on_patron_id"
  end

  create_table "visitor_messages", force: :cascade do |t|
    t.string "email"
    t.string "message_text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "votes", force: :cascade do |t|
    t.bigint "patron_id"
    t.bigint "event_id"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "sharing_image"
    t.string "square_sharing_image"
    t.index ["created_at"], name: "index_votes_on_created_at"
    t.index ["event_id", "patron_id"], name: "index_votes_on_event_id_and_patron_id", unique: true
    t.index ["event_id"], name: "index_votes_on_event_id"
    t.index ["patron_id"], name: "index_votes_on_patron_id"
    t.index ["status"], name: "index_votes_on_status"
  end

end
