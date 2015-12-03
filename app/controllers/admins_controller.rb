class AdminsController < ApplicationController
  before_action :require_user
  before_action :require_admin

  private

  def require_admin
    unless current_user.admin?
      flash[:danger] = "You do not have access."
      redirect_to home_path
    end
  end
end
