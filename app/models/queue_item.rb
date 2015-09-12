class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  validates_uniqueness_of :video_id,
    scope: :user_id

  delegate :category, to: :video
  delegate :title, to: :video, prefix: :video

  def category_name
    video.category.name
  end

  def rating
    review = video.reviews.where(user: user).first
    review.rating if review
  end
end
