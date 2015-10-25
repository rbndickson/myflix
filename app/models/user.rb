class User < ActiveRecord::Base
  has_many :reviews, -> { order 'created_at DESC' }
  has_many :queue_items, -> { order 'position' }

  has_many :following_relationships, class_name:  "Relationship",
                                     foreign_key: "follower_id",
                                     dependent:   :destroy

  has_many :leading_relationships, class_name:  "Relationship",
                                     foreign_key: "leader_id",
                                     dependent:   :destroy

  has_many :leaders, through: :following_relationships
  has_many :followers, through: :leading_relationships

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, on: :create, length: {minimum: 6}
  validates :full_name, presence: true

  has_secure_password validations: false

  before_create :generate_token

  def normalize_queue_item_positions
    queue_items.each_with_index do |queue_item, index|
      queue_item.update_attributes(position: index + 1)
    end
  end

  def video_queued?(video)
    queue_items.exists?(video: video)
  end

  def follow(other_user)
    following_relationships.create(leader_id: other_user.id)
  end

  def unfollow(other_user)
    following_relationships.find_by(leader_id: other_user.id).destroy
  end

  def follows?(other_user)
    leaders.include?(other_user)
  end

  def can_follow?(other_user)
    !(other_user == self || follows?(other_user))
  end

  def generate_token
    self.token = SecureRandom.urlsafe_base64
  end
end
