class ApplicationController < ActionController::Base
  protect_from_forgery
  
  #creates a session to key that will be paired with player id and saved as a cookie
  session :session_key => 'tic_tac_toe'
  
  
  def current_user
    
    #if the current user is accessing the site for the first time, generate a session for that user
    if session[:player_id].nil? then
      p = Player.create(:name => 'Player')
      p.init
      p.save
      session[:player_id] = p.id
    end
    
    #creates new id if player has invalid saved cookie. (usually because the database drop that id)
    if Player.find_by_id(session[:player_id]).nil? then 
      p = Player.create(:name => 'Player')
      p.init
      p.save
      session[:player_id] = p.id
    end
    
    #returns current user if it already exists, otherwise looks it up the newly created player session
    return @current_user ||= Player.find(session[:player_id])
  end
  
  helper_method :current_user
  
end
