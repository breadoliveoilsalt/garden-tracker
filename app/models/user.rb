class User < ActiveRecord::Base

  has_secure_password
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 8 }

  has_many :gardens
  has_many :species
  has_many :plantings

  def self.create_user_from_github(auth)
    create! do |user|
      user.name = auth.info.nickname
      user.password = SecureRandom.hex(10)
      user.provider = auth.provider
      user.uid = auth.uid
    end
  end

  def self.all_except(user)
    where.not(id: user.id)
  end


end
