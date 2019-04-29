class SessionsController < ApplicationController

  def new
    already_logged_in
    if_error
  end

  def create
    if params[:name].empty? || params[:password].empty?
      redirect_to login_path(error_message: "please fill in both the username & the password.")
    elsif !User.find_by(name: params[:name])
      redirect_to login_path(error_message: "that user name is not found in the database.")
    else
      user = User.find_by(name: params[:name])
      if user.authenticate(params[:password])
        session[:user_id] = user.id
        redirect_to user_path(user)
      else
        redirect_to login_path(error_message: "that password is incorrect.")
      end
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end

  def home
    already_logged_in
  end
end
