class QueueItemsController < ApplicationController
  before_action :require_user

  def index
    @queue_items = current_user.queue_items
  end

  def create
    video = Video.find(params[:video_id])

    if current_user_video_queued?(video)
      flash[:warning] = 'This video is already in your queue.'
    else
      create_queued_item(video)
    end
    
    redirect_to my_queue_path
  end

  def destroy
    queue_item = QueueItem.find_by(id: params[:id])
    queue_item.destroy if queue_item.user == current_user
    redirect_to my_queue_path
  end

  private

  def create_queued_item(video)
    QueueItem.create(
      video: video,
      user: current_user,
      position: new_queue_item_position
    )
  end

  def new_queue_item_position
    current_user.queue_items.count + 1
  end

  def current_user_video_queued?(video)
    current_user.queue_items.map(&:video).include?(video)
  end
end
