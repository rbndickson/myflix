class AppMailer < ActionMailer::Base
  default from: 'myflix@rbn-myflix.com'

  def welcome_email(user_id)
    @user = User.find_by(id: user_id)
    mail to: @user.email, subject: 'Welcome to MyFlix'
  end

  def forgot_password_email(user_id)
    @user = User.find_by(id: user_id)
    mail to: @user.email, subject: 'Please reset your password'
  end

  def invitation_email(invitation_id)
    @invitation = Invitation.find_by(id: invitation_id)
    mail to: @invitation.recipient_email, subject: 'Invitation to MyFlix'
  end
end
