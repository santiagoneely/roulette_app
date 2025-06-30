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

ActiveRecord::Schema[8.0].define(version: 2025_06_30_195317) do
  create_table "bets", force: :cascade do |t|
    t.integer "amount"
    t.string "color"
    t.integer "player_id", null: false
    t.integer "round_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "winnings"
    t.index ["player_id"], name: "index_bets_on_player_id"
    t.index ["round_id"], name: "index_bets_on_round_id"
  end

  create_table "players", force: :cascade do |t|
    t.string "name"
    t.integer "money", default: 10000
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "profile"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_players_on_deleted_at"
  end

  create_table "rounds", force: :cascade do |t|
    t.string "result"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "origin"
  end

  add_foreign_key "bets", "players"
  add_foreign_key "bets", "rounds"
end
