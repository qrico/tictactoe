class Ai < Player

  #This is a basic AI that returns the position of its next piece at the lowest available index of position

  @messages = Array.new(9)


  def get_move(positions, player_value)
    get_move(positions)
  end

  def get_move(positions)
    positions.each_with_index do |p, index|
      if p==0
        return index
      end
    end
    return false
  end
  
  def get_canned_message(num_moves)
    @messages = ["Welcome to my domain. I insist that you go first",  #0
      "I know just the spot", #1
      "your turn", #2
      "I shall foil your strategy", #3
      "your turn", #4
      "most perplexing", #5
      "your turn", #6
      "I will have you yet", #7
      "your turn"]  #8
    
    
    if num_moves > 8
      return @messages[8]
    else
      return @messages[num_moves]
    end
  end

end
