class User < ActiveRecord::Base
  has_secure_password
  # add validations HERE
  validates :name, presence: true, uniqueness: true#, message: "Error: You might not have provided a name, or your name might have been taken already."
  #validates :password, presence: true#, message: "Error: Please provide a password."

end
