class Video < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  index_name ["myflix", Rails.env].join('_')

  belongs_to :category
  has_many :reviews,-> { order "created_at DESC" }
  has_many :queue_items

  mount_uploader :large_cover, LargeCoverUploader
  mount_uploader :small_cover, SmallCoverUploader

  validates_presence_of :title, :description

  def self.search_by_title(search_term)
    return [] if search_term.blank?
    where('title ILIKE ?', "%#{search_term}%").order("created_at DESC")
  end

  def average_rating
    if self.reviews.count == 0
      nil
    else
      Review.where(video: self).average(:rating).round(1)
    end
  end

  def self.search(query)
    search_definition = {
      query: {
        multi_match: {
          query: query,
          type: "phrase",
          fields: ["title", "description"],
        }
      }
    }
    __elasticsearch__.search(search_definition)
  end

  def as_indexed_json(options={})
    as_json(only: [:title, :description])
  end
end
