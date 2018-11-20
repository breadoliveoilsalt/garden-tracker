class Planting < ActiveRecord::Base

  validates :quantity, presence: true, numericality: {only_integer: true, greater_than: 0}
  validates :garden_id, presence: true, numericality: {only_integer: true}
  validates :species_id, presence: true, numericality: {only_integer: true, message: "must be selected"}
  validates :user_id, presence: true, numericality: {only_integer: true}

  validate :valid_date_planted?, :valid_date_harvested?

  belongs_to :user
  belongs_to :garden
  belongs_to :species

  def valid_date_planted?
    if date_planted.present? && !Date.valid_date?(date_planted.year, date_planted.month, date_planted.day)
      errors.add(:date_planted, "is not a valid date")
    end
  end

  def valid_date_harvested?
    if date_harvested.present? && !Date.valid_date?(date_harvested.year, date_harvested.month, date_harvested.day)
      errors.add(:date_harvested, "is not a valid date")
    end
  end

  def name
    self.species.name
  end
end
