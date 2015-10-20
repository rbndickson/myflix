class Relationship < ActiveRecord::Base
  belongs_to :follower, class_name: 'User'
  belongs_to :leader, class_name: 'User'
  validates :follower_id, presence: true
  validates :leader_id, presence: true
  validates_uniqueness_of :follower_id, scope: [:leader_id], on: :create
end
