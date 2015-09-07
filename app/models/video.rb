class Video < ActiveRecord::Base
  belongs_to :category

  validates_presence_of :title, :description

  def self.search_by_title(search_term)
    # % shows wildcard location
    return [] if search_term.blank?
    where('title ILIKE ?', "%#{search_term}%").order("created_at DESC")
  end
end
