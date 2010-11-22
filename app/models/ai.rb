#AI is a SuperClass of all AI's and a Subclass of Player
class Ai < Player
  
  
  #This is a basic AI that returns the position of its next piece at the lowest available index of position


  has_many :games, :foreign_key => 'ai_id', :class_name => 'Game'

  @messages = Array.new(9)

  
  def get_move(positions, player_value)
    get_move(positions)
  end
  
  # The AI returns the position it wants to move, based on the game state
  # This Basic AI returns simply returns the next available position in the grid (left to right, top to bottom)
  def get_move(positions)
    positions.each_with_index do |p, index|
      if p==0
        return index
      end
    end
    return false
  end
  
  #returns a canned message based on the progress of the game. Can be extended to return richer and more varied messages
  def get_canned_message(num_moves)
    @messages = ["Welcome to my domain. I insist that you go first",  #0
      "I know just the spot", #1
      "Your turn", #2
      "I shall foil your strategy", #3
      "Your turn", #4
      "Most perplexing", #5
      "Your turn", #6
      "I will have you yet", #7
      "Your turn"]  #8
    
    
    if num_moves > 8
      return @messages[8]
    else
      return @messages[num_moves]
    end
  end

end
