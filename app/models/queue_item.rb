class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  delegate :category, to: :video
  delegate :title, to: :video, prefix: :video

  validates_numericality_of :position, { only_integer: true }

  def category_name
    video.category.name
  end

  def rating
    review = video.reviews.find_by(user: user)
    review.rating if review
  end
end
