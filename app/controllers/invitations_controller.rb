class InvitationsController < ApplicationController
  before_action :require_user

  def new
    @invitation = Invitation.new
  end

  def create
    @invitation = Invitation.new(invitation_params.merge!(inviter: current_user))

    if @invitation.save
      AppMailer.delay.invitation_email(@invitation)
      flash[:success] = "You have successfully invited #{@invitation.recipient_name}"
      redirect_to new_invitation_path
    else
      flash.now[:danger] = 'Please enter all details'
      render :new
    end
  end

  def invitation_params
    params.require(:invitation).permit(:recipient_email, :recipient_name, :message)
  end
end
