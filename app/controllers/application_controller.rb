class ApplicationController < ActionController::Base
  protect_from_forgery
  
  session :session_key => 'tic_tac_toe'
  
  def current_user
    
    if session[:player_id].nil? then
      p = Player.create(:name => 'Player', :total_games => 0, :total_games_won => 0, :total_games_lost => 0, :total_games_tied => 0)
      p.init
      p.save
      session[:player_id] = p.id
    end
    
    if Player.find(session[:player_id]).nil? then # TODO needs improvement
      p = Player.create(:name => 'Player', :total_games => 0, :total_games_won => 0, :total_games_lost => 0, :total_games_tied => 0)
      p.init
      p.save
      session[:player_id] = p.id
    end
    return @current_user ||= Player.find(session[:player_id])
  end
  
  helper_method :current_user
  
end
