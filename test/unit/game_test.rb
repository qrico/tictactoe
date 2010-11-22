require 'test_helper'

class GameTest < ActiveSupport::TestCase
  fixtures :players
  fixtures :games
	fixtures :ais
	
	p = Player.new()
  p.name = "human"
  p.init
  p.save
  
  ai = Player.new()
  ai.name = "ai"
  ai.save
	
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
  
  
  test "new game" do
    game = Game.new

    #game = Game.new_game(p, ai)
    game.start(p, ai)
    assert_equal(game.x_player, p)
    assert_equal(game.o_player, ai)
    assert (not game.game_won?)
    assert_equal(game.positions, [0, 0, 0, 0, 0, 0, 0, 0, 0])
    
  end
  
  test "new player" do
    assert_equal("human" , p.name)
    assert_equal("ai" , ai.name)
    puts p.total_games
  end
  
  test "add moves" do
    
    game = Game.new_game(p,ai)
    game.save
    
    game.add_move(p,0)
    game.add_move(ai,3)
    game.add_move(p,1)
    game.add_move(ai,4)
    game.add_move(p,2)
    assert_equal(game.positions, [1, 1, 1, 2, 2, 0, 0, 0, 0])
    
  end
  
  test "turns in order" do
    
    game = Game.new_game(p,ai)
    game.save
    
    game.add_move(p,0)
    game.add_move(p,1) #human player must wait his turn
    game.add_move(p,2)
    game.add_move(ai,1) #ai finally places his piece
    assert_equal(game.positions, [1, 2, 0, 0, 0, 0, 0, 0, 0])
    
  end
  
  test "game over and tie game" do 
    game = Game.new_game(p,ai)
    game.save
    
    # x|o|x
    # o|o|x
    # x|x|o
    game.add_move(p,0)
    game.add_move(ai,1)
    game.add_move(p,2)
    game.add_move(ai,3)
    game.add_move(p,5)
    game.add_move(ai,4)
    game.add_move(p,6)
    game.add_move(ai,8)
    game.add_move(p,7)
    assert_equal(game.positions, [1, 2, 1, 2, 2, 1, 1, 1, 2])
    assert(game.game_over?)
    assert(game.tie_game?) 
    assert(game.is_tie_game)
    
  end
    
  test "horizontal win" do
    game = Game.new_game(p,ai)
    game.save
    
    # x|x|x
    # o|o|.
    # .|.|.
    
    game.add_move(p,0)
    game.add_move(ai,3)
    game.add_move(p,1)
    game.add_move(ai,4)
    game.add_move(p,2)
    assert_equal(game.positions, [1, 1, 1, 2, 2, 0, 0, 0, 0])
    assert(game.game_won?)
    assert_equal(game.winner, p)
  end
  
  test "vertical win" do
    game = Game.new_game(p,ai)
    game.save
    
    # .|x|.
    # o|x|.
    # o|x|.
    
    game.add_move(p,1)
    game.add_move(ai,3)
    game.add_move(p,4)
    game.add_move(ai,6)
    game.add_move(p,7)
    assert_equal(game.positions, [0, 1, 0, 2, 1, 0, 2, 1, 0])
    assert(game.game_won?)
    assert_equal(game.winner, p)
  end
  
  test "diagonal win" do
    game = Game.new_game(p,ai)
    game.save
    
    # o|x|.
    # x|o|.
    # .|x|o
    
    game.add_move(p,1)
    game.add_move(ai,0)
    game.add_move(p,3)
    game.add_move(ai,4)
    game.add_move(p,7)
    game.add_move(ai,8)
    assert_equal(game.positions, [2, 1, 0, 1, 2, 0, 0, 1, 2])
    assert(game.game_won?)
    assert_equal(game.winner, ai)
  end
  
  test "diagonal win 2" do
    game = Game.new_game(p,ai)
    game.save
    
    # o|o|x
    # .|x|.
    # x|.|.
    
    game.add_move(p,2)
    game.add_move(ai,0)
    game.add_move(p,4)
    game.add_move(ai,1)
    game.add_move(p,6)
    assert_equal(game.positions, [2, 2, 1, 0, 1, 0, 1, 0, 0])
    assert(game.game_won?)
    assert_equal(game.winner, p)
  end
  
  test "basic ai" do
    game = Game.new_game(p,ai)
    game.save
    
    game.add_move(p,2)
    n = game.get_ai_move
    assert_equal(0, n)
    game.add_move(ai,n)
    game.add_move(p,1)
    n = game.get_ai_move
    assert_equal(3, n)
    game.add_move(ai,n)
    
    #result
    # o|x|x
    # o|.|.
    # .|.|.
    
    assert_equal(game.positions, [2, 1, 1, 2, 0, 0, 0, 0, 0])
  end
  
end
