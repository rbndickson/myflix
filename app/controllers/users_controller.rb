class UsersController < ApplicationController
  before_action :require_user, only: [:show]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.valid?
      charge = StripeWrapper::Charge.create(
        amount: 999,
        source: params[:stripeToken],
        description: "Sign up charge for #{@user.email}"
      )
      if charge.successful?
        @user.save
        handle_invitation
        AppMailer.delay.welcome_email(@user.id)
        flash[:success] = "You have been registered, please sign in."
        redirect_to sign_in_path
      else
        flash.now[:danger] = charge.error_message
        render :new
      end
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def new_with_invitation_token
    invitation = Invitation.find_by(token: params[:token])
    if invitation
      @user = User.new(email: invitation.recipient_email)
      @invitation_token = invitation.token
      render :new
    else
      redirect_to expired_token_path
    end
  end

  private

  def handle_invitation
    if params[:invitation_token].present?
      invitation = Invitation.find_by(token: params[:invitation_token])
      @user.follow!(invitation.inviter)
      invitation.inviter.follow!(@user)
      invitation.update_column(:token, nil)
    end
  end

  def user_params
    params.require(:user).permit(:email, :password, :full_name)
  end
end
