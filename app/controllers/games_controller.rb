class GamesController < ApplicationController
  # GET /games
  # GET /games.xml
  def index
    @games = Game.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @games }
    end
  end

  # GET /games/1
  # GET /games/1.xml
  def show
    @game = Game.find(params[:id])
    #place_piece
    @pos = params[:position]
    @ai = params[:ai]
    if !@pos.nil? and (@game.last_move == @game.o_player) then
      @pos = @pos.to_i
      #@player = Player.find_by_id(@game.x_player_id).name
      player = Player.find_by_id(@game.x_player_id)
      @game.add_move(player, @pos)
      @game.save
    end
    if (@ai == '1') and (@game.last_move == @game.x_player) then #ai_move
      pos = @game.get_ai_move
      player = Player.find_by_id(@game.o_player_id)
      @game.add_move(player, pos)
      @game.save
    end
    
    #check game over
    if @game.game_over?
      if @game.is_tie_game?
        flash[:notice] = "AI: "<<"I almost had you. There will be a victor next time!      TIE GAME"
      elsif @game.game_won?
        if @game.winner == @game.x_player
          flash[:notice] = "AI: "<<"GG. I shall have to reformulate my strategy.     GAME OVER"
        else
          flash[:notice] = "AI: "<<"I am the champion my friend.   GAME OVER"
        end
      end
    #else get new message and continue
    else  
      moves = @game.num_moves
      if moves >= 0 then
        flash[:notice] = "Basic AI: "<<@game.get_ai_canned_message(moves)
      end
    end
     
    respond_to do |format|
      format.html {}#redirect_to(@game, :notice => 'Basic AI: Welcome to my domain. My pity for you insists that you go first')}
      format.xml  { render :xml => @game }
      #format.js
    end
    #render :action => 'play'
  end
  
  def place_piece
    #@game = Game.find(params[:id])
    #pos = params[:position]
    #@game.add_move(@game.x_player, 0)
    #flash[:notice] = "Well played, but I know what I am doing"
    #respond_to do |format|
    #  format.html { render :action => "edit" } #redirect_to(games_url)
    #  
    #end
    
    
  end


  # GET /games/new
  # GET /games/new.xml
  def new
    @game = Game.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @game }
    end
  end

  # GET /games/1/edit
  def edit
    @game = Game.find(params[:id])
    @game.add_move(@game.x_player, 0)
  end

  # POST /games
  # POST /games.xml
  def create
    @game = Game.new(params[:id])
    x = current_user
    o = Player.new(:name => "Computer")
    @game = @game.start(x,o)
    (0..@game.gamesize-1).each do |i|
      @game.positions[i] = 0
    end
    
    respond_to do |format|
      if @game.save
        
        format.html { redirect_to(@game) }
        format.xml  { render :xml => @game, :status => :created, :location => @game }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @game.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /games/1
  # PUT /games/1.xml
  def update
    @game = Game.find(params[:id])

    respond_to do |format|
      if @game.update_attributes(params[:game])
        format.html { redirect_to(@game, :notice => 'Game was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @game.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1
  # DELETE /games/1.xml
  def destroy
    @game = Game.find(params[:id])
    @game.destroy

    respond_to do |format|
      format.html { redirect_to(games_url) }
      format.xml  { head :ok }
    end
  end
end
