class ForgotPasswordController < ApplicationController
  def create
    user = User.find_by(email: params[:email])
    if user
      AppMailer.forgot_password_email(user).deliver
      redirect_to forgot_password_confirmation_path
    else
      flash[:danger] = 'Email cannot be blank.' if params[:email].blank?
      flash[:danger] = 'Email error.' if params[:email].present?
      redirect_to forgot_password_path
    end
  end
end
