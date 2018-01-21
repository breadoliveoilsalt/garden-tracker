class User < ActiveRecord::Base
  has_secure_password
  # add validations HERE
  validates :name, presence: true, uniqueness: true
  validates :password, presence: true

end
