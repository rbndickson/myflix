class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  delegate :category, to: :video
  delegate :title, to: :video, prefix: :video

  validates_numericality_of :position, only_integer: true

  def category_name
    video.category.name
  end

  def rating
    review.rating if review
  end

  def rating=(new_rating)
    if review
      review.update_column(:rating, new_rating)
    else
      new_review = Review.new(user: user, video: video, rating: new_rating)
      new_review.save(validate: false)
    end
  end

  private

  def review
    @review ||= Review.find_by(user: user, video: video)
  end
end
