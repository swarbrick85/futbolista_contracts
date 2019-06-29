#new version: replica

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def authorization
    if_not_logged_in
    not_your_page_user_id_v
  end

  def if_not_logged_in
    if session[:user_id].nil?
      redirect_to login_path(error_message: "please log in")
    end
  end

  def if_error
    if params[:error_message]
      @error_message = params[:error_message]
    end
  end

  def not_your_page_user_id_v
    if session[:user_id] != params[:user_id].to_i
      redirect_to user_path(User.find_by_id(session[:user_id]), error_message: "that is not your page")
    end
  end

  def not_your_page_id_v
    if session[:user_id] != params[:id].to_i
      redirect_to user_path(User.find_by_id(session[:user_id]), error_message: "that is not your page")
    end
  end

  def already_logged_in
    if !session[:user_id].nil?
      redirect_to user_path(User.find_by_id(session[:user_id]), error_message: "you are already logged in")
    end
  end

  def self.not_your_data
    if session[:user_id] != self.find_by_id(params[:id]).user.id
      redirect_to user_path(User.find_by_id(session[:user_id]), error_message: "that is not your data")
    end
  end

end
