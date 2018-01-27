class Species < ActiveRecord::Base

  PRODUCT_TYPES = [
    "vegetables",
    "fruits",
    "herbs",
    "legumes",
    "seeds",
    "nuts",
    "non-edible",
    "other"
  ]

  SUN_LEVELS = [
    "shade",
    "part-shade",
    "full-sun"
  ]

  validates :name, presence: true
  validates :product, presence: true, inclusion: { in: Species::PRODUCT_TYPES }
  validates :sunlight, presence: true, inclusion: { in: Species::SUN_LEVELS }
  validates :user_id, presence: true, numericality: {only_integer: true}

  belongs_to :user
  has_many :species_garden
  has_many :gardens, through: :species_garden
  has_many :plantings

end
