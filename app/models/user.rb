class User < ActiveRecord::Base
  has_secure_password
  # add validations HERE
  validates :name, presence: true, uniqueness: true#, message: "Error: You might not have provided a name, or your name might have been taken already."
  #validates :password, presence: true#, message: "Error: Please provide a password."


  has_many :gardens
  has_many :species
  has_many :plantings

  def self.create_user_from_github(auth)
    create! do |user|
      user.name = auth.extra.all_emails[0].email
      user.password = auth.uid
      user.provider = auth.provider
      user.uid = auth.uid
      user.oath_token = auth.credentials.token # Should I put this in bracket form like the others?
    end
  end


end
