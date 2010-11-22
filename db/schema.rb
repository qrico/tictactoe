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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20101122004333) do

  create_table "ais", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "games", :force => true do |t|
    t.string   "title"
    t.integer  "x_player_id"
    t.integer  "o_player_id"
    t.integer  "ai_id"
    t.integer  "winner_id"
    t.integer  "last_move_id"
    t.integer  "num_moves"
    t.integer  "gamesize"
    t.text     "positions"
    t.boolean  "is_tie_game"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "players", :force => true do |t|
    t.string   "name"
    t.string   "player_type"
    t.integer  "total_games"
    t.integer  "total_games_won"
    t.integer  "total_games_lost"
    t.integer  "total_games_tied"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
