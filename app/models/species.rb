class Species < ActiveRecord::Base

  PRODUCT_TYPES = [
    "vegetable",
    "fruit",
    "herb",
    "legume",
    "seed",
    "nut",
    "non-edible",
    "other"
  ]

  SUN_LEVELS = [
    "shade",
    "part-shade",
    "full-sun"
  ]

  validates :name, presence: true
  validates :product, presence: true, inclusion: { in: Species::PRODUCT_TYPES }#%w(vegetable fruit herb legume seed nut non-edible other)} # message: "%{value} is not a valid size" }
  validates :sunlight, presence: true, inclusion: { in: Species::SUN_LEVELS }
  validates :user_id, presence: true, numericality: {only_integer: true}

  belongs_to :user
  has_many :species_garden
  has_many :gardens, through: :species_garden
  has_many :plantings

  def gimme
    self.class.PRODUCT_TYPES
  end

end
