class CreateGames < ActiveRecord::Migration
  def self.up
    create_table :games do |t|
      t.string :title
      t.integer :x_player_id
      t.integer :o_player_id
      t.integer :ai_id
      t.integer :winner_id
      t.integer :last_move_id
      t.integer :num_moves
      t.integer :gamesize
      t.text :positions
      t.boolean :is_tie_game

      t.timestamps
    end
  end

  def self.down
    drop_table :games
  end
end
