class SessionsController < ApplicationController

  def new
    redirect_to home_path if signed_in?
  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to home_path
      flash[:success] = 'You are now signed in.'
    else
      redirect_to sign_in_path
      flash[:danger] = 'Error in signing in.'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
    flash[:info] = 'You have now signed out.'
  end

end
