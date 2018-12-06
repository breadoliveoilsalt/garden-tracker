class Garden < ActiveRecord::Base

  validates :name, presence: true
  validates :square_feet, numericality: {only_integer: true, message: "must be a whole number"}
  validates :user_id, presence: true, numericality: {only_integer: true}

  belongs_to :user
  has_many :species_garden
  has_many :species, through: :species_garden
  has_many :plantings

  accepts_nested_attributes_for :plantings

  def self.get_active_gardens(user_id)
    Garden.where("user_id = ? AND active = ?", user_id, true).order(:name)
  end

  def self.get_inactive_gardens(user_id)
    Garden.where("user_id = ? AND active = ?", user_id, false).order(:name)
  end

  def get_upcoming_maturities

    upcoming_maturities = self.plantings.select { |planting| !planting.date_harvested && planting.expected_maturity_date && planting.expected_maturity_date > Date.current }

    if upcoming_maturities.empty?
      nil
    else
      upcoming_maturities
    end

  end

end
