class Game < ActiveRecord::Base
  attr_accessor :safe_gaurd_count

  belongs_to :x_player, :foreign_key => 'x_player_id', :class_name => 'Player'
  belongs_to :o_player, :foreign_key => 'o_player_id', :class_name => 'Player'
  belongs_to :last_move, :foreign_key => 'last_move_id', :class_name => 'Player'
  belongs_to :winner, :foreign_key => 'winner_id', :class_name => 'Player'
  belongs_to :ai, :foreign_key => 'ai_id', :class_name => 'Ai'
  #has_one :ai, :class_name => 'Ai'

  serialize :positions

  validate :title,  :presence => true

  attr_reader :play_status

  # This Class has been tested extensively as it is the heart of the model

  # This Class method returns a new Game object with the associated players X and O
  def self.new_game(x_player, o_player)
    #x = 1, o = 2
    g = Game.new(:title => "#{x_player.name} vs. #{o_player.name}")
    g.x_player = x_player
    g.o_player = o_player
    size = 9 # Game is a default square tic tac toe game, but can be larger or smaller. Game model supports this. 
    g.gamesize = size
    g.positions = Array.new(size, 0) #empty position is 0. positions 0-8
    g.num_moves = 0
    g.last_move = o_player
    ai = Ai.new(:name => "Basic AI") #Uncomment to make default AI
    #ai = Random_Ai.new(:name => "Basic AI") #Random is now the default
    ai.init
    ai.save
    g.ai = ai
    g.save
    return g
  end
  
  #initializes and starts the game
  def start(x_player,o_player)
    g = self
    g.title = "#{x_player.name} vs. #{o_player.name}"
    g.x_player = x_player
    g.o_player = o_player
    size = 9
    g.gamesize = size
    g.positions = Array.new(size, 0) #empty position is 0. positions 0-8 
    g.num_moves = 0
    g.last_move = o_player
    ai = Ai.new(:name => "Basic AI") #Uncomment to make default AI
    #ai = Random_Ai.new(:name => "Basic AI")
    ai.init
    ai.save
    g.ai = ai
    g.save
 
    return g
  end

  # Returns true if the game has been tied or won by a player
  def game_over?
    if tie_game? or game_won?
      return true
    else 
      return false
    end
  end

  # Returns true when it is a tied game
  def tie_game?
    if self.num_moves == gamesize and not game_won?
      if !self.is_tie_game
        x_player.total_games_tied += 1
        x_player.save
        self.is_tie_game = true
        self.save
      end
      return true
    else 
      return false
    end
  end

  # Adds new move if it can be legally placed in the given position (cant go out of turn, cant place in a take spot, cant place when game is over)
  def add_move(player, position)
    if not players_turn?(player) #check 
      #self.errors.add("It is not your turn", "") 
      return #break and return error messages
    end
    if game_won?
      #self.errors.add("The game is already over", "")
      return #break and return error messages
    end
    if tie_game?
      self.errors.add("The game is already over", "")
      return #break and return error messages
    end

    #check if position is open (available)
    if move_available?(position)
      if player == x_player
        self.positions[position] = 1
      else 
        self.positions[position] = 2
      end
      self.last_move = player
      self.num_moves += 1
    else
      self.errors.add("That move has already been taken", "")
    end 
  end

  def move_available?(position)
    return self.positions[position] == 0
  end

  # Returns true if it is the given player's turn
  def players_turn?(player)
    #game already over
    if not winner.nil? then
      self.errors.add("That move not allowed, game is already over.", "")
      return false

      #player's turn?
    elsif (self.num_moves > 0 ) and last_move.equal?(player) then
      self.errors.add('move cannot be played, it is not your turn.', '')
      return false
    else 
      return true
    end

  end


  # Returns true if the game has been won
  def game_won?
    if self.num_moves < ((self.gamesize**0.5)*2-1 ) #ie for standard 9 tile game, 5 moves are required for a player to win
      return false
    else
      if last_move == x_player
        check = 1
      else 
        check = 2
      end
      h = check_horizontal(check) #checks for horizontal wins
      v = check_vertical(check) #checks for vertical wins
      d = check_diagonal(check) #checks for diagonal wins
      if h or (v or d)
        if self.winner.nil? # Only set winner once. Prevents totals being added more than once.
          self.winner = last_move
          if self.winner == o_player
            x_player.total_games_lost += 1
          else
            x_player.total_games_won += 1
            x_player.total_games += 1
          end
        end
        x_player.save
        self.save
        return true
      end
      
      return false
    end
    return false
  end

  # Returns true if there is a horizontal win for the player being checked
  def check_horizontal(check) #check only the last players move
    n = (self.gamesize**0.5)  #n x n game
    win = false
    (0..n-1).each do |i| #every row
      row = true
      (0..(n-1)).each do |j| #every colomun
        if self.positions[i*n+j] != check 
          row = false #if one of the positions does not belong to the player, false is set, and loop broken to save time
          break
        end
      end
      if row
        return true #if the whole row has stayed true, there is a win
      end
    end
    return win
  end

  # Returns true if there is a vertical win for the player being checked
  def check_vertical(check)
    n = (self.gamesize**0.5)  #n x n game
    win = false
    (0..n-1).each do |j| #every column
      col = true
      (0..(n-1)).each do |i| #every column
        if self.positions[i*n+j] != check 
          col = false
          break
        end
      end
      if col
        return true
      end
    end
    return win
  end

  # Returns true if there is a diagonal win for the player being checked
  def check_diagonal(check)
    n = Integer(self.gamesize**0.5) #n x n game
    win = false
    #c hecks pos slope, neg slope diagonals, from corner to corner
    pos = true
    neg = true
    #check the negative slope
    (0..(n-1)).each do |i| 
      if self.positions[i*n+i] != check
        neg = false
      end
    end
    #check the positive slope
    (0..(n-1)).each do |i|
      if self.positions[i*n+(n-1-i)] != check
        pos = false
      end
    end
    diag = pos || neg
    return diag

  end

  # Returns this AI's next move, based on the game state
  def get_ai_move(positions)
    return self.ai.get_move(positions)
  end
  
  # Returns this game's AI's next move, based on the game state
  def get_ai_move
    return Ai.new.get_move(self.positions)
    #return self.ai.get_move(self.positions) 
  end
  
  # Returns this game's AI's next move, based on the game state
  def get_ai_canned_message(num_moves)
    return self.ai.get_canned_message(num_moves)
    #return Ai.new.get_canned_message(num_moves)
  end


end
