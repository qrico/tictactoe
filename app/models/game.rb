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


  # This Class method returns a new Game object with the associated players X and O
  def self.new_game(x_player, o_player)
    #x = 1, o = 2
    g = Game.new(:title => "#{x_player.name} vs. #{o_player.name}")
    g.x_player = x_player
    g.o_player = o_player
    size = 9
    g.gamesize = size
    g.positions = Array.new(size, 0) #empty position is 0. positions 0-8
    g.num_moves = 0
    g.last_move = o_player
    ai = Ai.new
    ai.init
    ai.save
    g.save
    return g
  end
  
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
    ai = Ai.new
    ai.init
    ai.save
    g.save
 
    return g
  end

  # Returns true if the game has been won or equalized
  def game_over?
    if tie_game? or game_won?
      return true
    else 
      return false
    end
  end

  # Returns true if the game has been equalized
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

  # adds new move if legal (cant go out of turn, cant place in a take spot)
  def add_move(player, position)
    if not players_turn?(player)
      return #break and return error messages
    end
    if game_won?
      return #break and return error messages
    end
    if tie_game?
      return #break and return error messages
    end

    # new move object, for records. Not using database object heavily though
    #move = Move.new(:title => "Move to position #{position}")
    #move.player = player
    #move.position = position

    #check if available
    if move_available?(position)
      if player == x_player
        self.positions[position] = 1
      else 
        self.positions[position] = 2
      end
      self.last_move = player
      self.num_moves += 1
    else
      self.errors.add("move has already been taken", "")
    end 
  end

  def move_available?(position)
    return self.positions[position] == 0
  end

  def players_turn?(player)
    #game already over
    if not winner.nil? then
      self.errors.add("move not allowed, game is already over.", "")
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
      h = check_horizontal(check)
      v = check_vertical(check)
      d = check_diagonal(check)
      if h or (v or d)
        if self.winner.nil?
          self.winner = last_move
          if self.winner == o_player
            puts x_player
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

  def check_horizontal(check) #check only the last players move
    n = (self.gamesize**0.5)  #n x n game
    win = false
    (0..n-1).each do |i| #every row
      row = true
      (0..(n-1)).each do |j| #every colomun
        if self.positions[i*n+j] != check 
          row = false
          break
        end
      end
      if row
        return true
      end
    end
    return win
  end

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

  def check_diagonal(check)
    n = Integer(self.gamesize**0.5) #n x n game
    win = false
    #pos slope, neg slope, corner to corner
    pos = true
    neg = true
    (0..(n-1)).each do |i| 
      if self.positions[i*n+i] != check
        neg = false
      end
    end
    (0..(n-1)).each do |i|
      if self.positions[i*n+(n-1-i)] != check
        pos = false
      end
    end
    diag = pos || neg
    return diag

  end

  def get_ai_move(position)
    return self.ai.get_move(position)
  end
  def get_ai_move
    return Ai.new.get_move(self.positions)
    #return self.ai.get_move(self.positions) TODO figure out why ai wont save to the database
  end
  
  def get_ai_canned_message(num_moves)
    return Ai.new.get_canned_message(num_moves)
  end


end
