class CreateAis < ActiveRecord::Migration
  def self.up
    create_table :ais do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :ais
  end
end
