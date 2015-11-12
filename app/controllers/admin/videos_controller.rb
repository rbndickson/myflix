class Admin::VideosController < ApplicationController
  before_action :require_user
  before_action :require_admin

  def new
    @video = Video.new
  end

  def create
    @video = Video.new(video_params)

    if @video.save
      redirect_to new_admin_video_path
      flash[:success] = "You have added #{@video.title}"
    else
      flash[:danger].now = "Video has not been added - Please check the errors"
      render :new
    end
  end

  private

  def video_params
    params.require(:video).permit(:title, :category_id, :description, :small_cover, :large_cover, :video_url)
  end

  def require_admin
    unless current_user.admin?
      flash[:danger] = "You do not have access"
      redirect_to home_path
    end
  end
end
