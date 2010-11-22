class CreatePlayers < ActiveRecord::Migration
  def self.up
    create_table :players do |t|
      t.string :name
      t.string :player_type
      t.integer :total_games
      t.integer :total_games_won
      t.integer :total_games_lost
      t.integer :total_games_tied

      t.timestamps
    end
  end

  def self.down
    drop_table :players
  end
end
