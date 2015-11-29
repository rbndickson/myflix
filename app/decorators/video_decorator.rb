class VideoDecorator < Draper::Decorator
  delegate_all

  def average_rating
    if object.average_rating.present?
      "Rating: #{object.average_rating}/5.0"
    else
      "There are no reviews"
    end
  end
end
