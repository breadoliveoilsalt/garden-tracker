class User < ActiveRecord::Base

  has_secure_password
  validates :name, presence: true, uniqueness: true
  validates :password, length: { in: 8..15 }


  has_many :gardens
  has_many :species
  has_many :plantings

  def self.create_user_from_github(auth)
    create! do |user|
      user.name = auth.info.nickname
      user.password = SecureRandom.hex(10) # has_secure_password requires a password. This generates random one.
        # Double check that you don't need require 'securerandom' somewhere.
      user.provider = auth.provider
      user.uid = auth.uid
      # user.oath_token = auth.credentials.token
        # Commented out line above b/c not sure why I'd need it.  Got it form one of those tutorials on line
    end
  end

  def self.all_except(user)
    where.not(id: user.id)
  end


end
