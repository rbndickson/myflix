class User < ActiveRecord::Base
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, on: :create, length: {minimum: 6}
  validates :full_name, presence: true

  has_secure_password validations: false
end
