class Species < ActiveRecord::Base

  CATEGORIES = [
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

  validates :name, presence: true, uniqueness: {scope: :user_id, case_sensitive: false }
  validates :category, presence: true, inclusion: { in: Species::CATEGORIES }
  validates :sunlight, presence: true, inclusion: { in: Species::SUN_LEVELS }
  validates :user_id, presence: true, numericality: {only_integer: true}
  validates :days_to_maturity, numericality: {only_integer: true}, allow_nil: true

  belongs_to :user
  has_many :species_garden
  has_many :gardens, through: :species_garden
  has_many :plantings

end
