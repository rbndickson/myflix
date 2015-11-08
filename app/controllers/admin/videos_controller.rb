class Admin::VideosController < ApplicationController
  before_action :require_user
  before_action :require_admin

  def new
    @video = Video.new
  end

  def require_admin
    unless current_user.admin?
      flash[:danger] = "You do not have access"
      redirect_to home_path
    end
  end
end
