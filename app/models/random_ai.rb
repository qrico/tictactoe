# Implemented but not used
class Random_Ai < Ai
  
  
  #This is a basic AI that returns the position of its next piece at a random available position


  has_many :games, :foreign_key => 'ai_id', :class_name => 'Game'

  @messages = Array.new(9) #TODO save array in database

  
  def get_move(positions, player_value)
    get_move(positions)
  end
  
  # The AI returns the position it wants to move, based on the game state
  # This Basic AI returns simply returns the next available position in the grid (left to right, top to bottom)
  def get_move(positions)

    index = 0
    while true
      r = rand(positions.size)
      if index== r and index == 0 #check rand and space empty
          return r
      end
      index+=1
      if index == positions.size
        index = 0
      end
    end

  end
  
  # returns a canned message based on the progress of the game. Can be extended to return richer and more varied messages
  # use superclass messages
  # def get_canned_message(num_moves) end

end
