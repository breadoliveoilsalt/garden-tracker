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

  validate :valid_date_planted?, :valid_date_harvested?

  belongs_to :user
  has_many :species_garden
  has_many :gardens, through: :species_garden
  has_many :plantings

  def valid_date_planted?
    if date_planted.present? && !Date.valid_date?(date_planted.year, date_planted.month, date_planted.day)
      errors.add(:date_planted, "is not a valid date")
    end
  end

  def valid_date_harvested?
    if date_harvested.present?
      if date_harvested.present? && !Date.valid_date?(date_harvested.year, date_harvested.month, date_harvested.day)
        errors.add(:date_harvested, "is not a valid date")
      end
    end

  end

end
