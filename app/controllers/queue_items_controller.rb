class QueueItemsController < ApplicationController
  before_action :require_user

  def index
    @queue_items = current_user.queue_items
  end

  def create
    queue_item = QueueItem.new(
      video_id: params[:video_id],
      user: current_user,
      position: new_queue_item_position
    )
    if queue_item.save
      redirect_to my_queue_path
    else
      flash[:warning] = 'This video is already in your queue.'
      redirect_to my_queue_path
    end
  end

  private

  def new_queue_item_position
    current_user.queue_items.count + 1
  end
end
