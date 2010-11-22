class Player < ActiveRecord::Base
  attr_accessible :name, :type
	validate :player_type, :presence => true  #human or ai
	validates_presence_of :name
  ##validates_numericality_of :total_games, :only_integer => true
  ##validates_numericality_of :total_games_won, :only_integer => true
  ##validates_numericality_of :total_games_lost, :only_integer => true
  ##validates_numericality_of :total_games_tied, :only_integer => true 
	
	has_many :games, :foreign_key => 'player_x_id', :class_name => 'Game'
	

  def new
    self.total_games = 0
    self.total_games_won = 0
    self.total_games_lost = 0
    self.total_games_tied = 0
    self.save
  end
  
  def init
    self.total_games = 0
    self.total_games_won = 0
    self.total_games_lost = 0
    self.total_games_tied = 0
    self.save
  end
  
  #accessor methods
	def get_total_games_played

	end

	def get_total_games_won

	end

	def get_total_games_equalized

	end	
	
	def get_total_games_lost
      
	end
	
	def game_won
	  
  end
  
  def game_lost
    
  end
  
  def game_tied
   
  end
end
