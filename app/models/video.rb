class Video < ActiveRecord::Base
  belongs_to :category
  has_many :reviews,-> { order "created_at DESC" }

  validates_presence_of :title, :description

  def self.search_by_title(search_term)
    return [] if search_term.blank?
    where('title ILIKE ?', "%#{search_term}%").order("created_at DESC")
  end

  def average_rating
    reviews = self.reviews
    if reviews.count == 0
      nil
    else
      total = reviews.inject(0.0) do |sum, review|
        sum + review[:rating].to_i
      end
      average = total / reviews.count
      average.round(1)
    end
  end
end
