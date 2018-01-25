class Species < ActiveRecord::Base

  validates :name, presence: true
  validates :product, presence: true, inclusion: { in: %w(vegetable fruit herb legume seed nut non-edible other)} # message: "%{value} is not a valid size" }
  validates :sunlight, presence: true, inclusion: { in: %w(shade part-shade full-sun)}
  validates :user_id, presence: true, numericality: {only_integer: true}

  belongs_to :user
  has_many :garden_species
  has_many :gardens, through: :garden_species
  has_many :plantings

product
end result
matures_into
produces
harvest
purpose
becomes

end
