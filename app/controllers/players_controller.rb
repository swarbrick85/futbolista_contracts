class PlayersController < ApplicationController

  def index
    authorization
    @players = Player.where(user_id: session[:user_id])
  end

  def show
    authorization
    if Player.find_by(id: params[:id]) && session[:user_id] == params[:user_id].to_i
      if session[:user_id] != Player.find_by_id(params[:id]).user.id
        redirect_to user_path(User.find_by_id(session[:user_id]), error_message: "that is not your data")
      else
        @player = Player.find_by_id(params[:id])
      end
    elsif !Player.find_by_id(params[:id]) && session[:user_id] == params[:user_id].to_i
      redirect_to user_path(User.find_by_id(session[:user_id]), error_message: "there is not a player with that id")
    end
  end

  def new
    authorization
    @player = Player.new
  end

  def create
      @player = Player.new(player_params)
      if @player.save
        redirect_to user_player_path(@player.user, @player)
      else
        render 'players/new'
      end
  end

  def edit
    authorization
    if session[:user_id] != Player.find_by_id(params[:id]).user.id
      redirect_to user_path(User.find_by_id(session[:user_id]), error_message: "that is not your data")
    end
    if_error
    @player = Player.find_by_id(params[:id])
  end

  def update
    if params[:player][:name].nil? || params[:player][:agent_id].nil? || params[:player][:club_id].nil?
      redirect_to edit_user_player_path(User.find_by_id(params[:player][:user_id]), Player.find_by_id(params[:player][:id]), error_message: "a player must have a name, an agent, and a club")
    elsif params[:player][:name].empty? || params[:player][:agent_id].empty? || params[:player][:club_id].empty?
      redirect_to edit_user_player_path(User.find_by_id(params[:player][:user_id]), Player.find_by_id(params[:player][:id]), error_message: "a player must have a name, an agent, and a club")
    elsif params[:player][:name] != Player.find_by_id(params[:player][:id]).name
      if Player.find_by(user_id: params[:player][:user_id], name: params[:player][:name])
        redirect_to edit_user_player_path(User.find_by_id(params[:player][:user_id]), Player.find_by_id(params[:player][:id]), error_message: "you have another player by that name")
      else
        @player = Player.find_by(user_id: params[:player][:user_id], id: params[:player][:id])
        @player.update(player_params)
        redirect_to user_player_path(@player.user, @player)
      end
    else
      @player = Player.find_by(user_id: params[:player][:user_id], id: params[:player][:id])
      @player.update(player_params)
      redirect_to user_player_path(@player.user, @player)
    end
  end

  def destroy
    @player = Player.find_by(user_id: params[:user_id], id: params[:id])
    @player.delete
    redirect_to user_players_path(User.find_by_id(session[:user_id]))
  end

  def player_params
    params.require(:player).permit(:name, :country_of_origin, :position, :agent_id, :club_id, :contract_id, :user_id, :id)
  end

end
