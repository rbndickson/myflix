class Admin::VideosController < AdminsController

  def new
    @video = Video.new
  end

  def create
    @video = Video.new(video_params)

    if @video.save
      redirect_to new_admin_video_path
      flash[:success] = "You have added #{@video.title}"
    else
      flash.now[:danger] = "Video has not been added - Please check the errors"
      render :new
    end
  end

  private

  def video_params
    params.require(:video).permit(:title, :category_id, :description, :small_cover, :large_cover, :video_url)
  end
end
