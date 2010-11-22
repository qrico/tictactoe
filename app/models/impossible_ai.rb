#TODO not implemented
class Impossible_Ai < Ai
  
  
  #This is a basic AI that returns the position of its next piece at the lowest available index of position


  has_many :games, :foreign_key => 'ai_id', :class_name => 'Game'

  @messages = Array.new(9)

  
  # def get_move(positions, player_value)
  #   get_move(positions)
  # end
  
  # The AI returns the position it wants to move, based on the game state
  # This Basic AI returns simply returns the next available position in the grid (left to right, top to bottom)
  
  #def get_move(positions) end

  
  #returns a canned message based on the progress of the game. Can be extended to return richer and more varied messages
  #def get_canned_message(num_moves) end
  

end
