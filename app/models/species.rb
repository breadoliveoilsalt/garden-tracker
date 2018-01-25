class Species < ActiveRecord::Base

  validates :name, presence: true
  validates :type, presence: true, inclusion: { in: %w(vegetable fruit bean seed nut other)} # message: "%{value} is not a valid size" }
  validates :sunlight, presence: true, inclusion: { in: %w(shade part-shade full-sun)}

  has_many :garden_species
  has_many :gardens, through: :garden_species
  has_many :plantings


end
