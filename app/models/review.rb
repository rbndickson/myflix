class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :video, touch: true

  validates_presence_of :rating, :content
end
