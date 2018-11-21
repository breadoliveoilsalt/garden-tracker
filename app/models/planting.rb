class Planting < ActiveRecord::Base

  validates :quantity, presence: true, numericality: {only_integer: true, greater_than: 0}
  validates :garden_id, presence: true, numericality: {only_integer: true}
  validates :species_id, presence: true, numericality: {only_integer: true, message: "must be selected"}
  validates :user_id, presence: true, numericality: {only_integer: true}

  validate :valid_date_planted?, :valid_date_harvested?

  belongs_to :user
  belongs_to :garden
  belongs_to :species

  before_save :set_expected_maturity_date
  # before_update :set_expected_maturity_date

  def valid_date_planted?
    begin
      Date.parse(self.date_planted_before_type_cast)
    rescue
      self.errors.add(:date_planted, "is not a valid date")
    end
  end

  def valid_date_harvested?
    if self.date_harvested_before_type_cast
      begin
        Date.parse(self.date_harvested_before_type_cast)
      rescue
        self.errors.add(:date_harvested, "is not a valid date")
      end
    end
  end

  def name
    self.species.name
  end

  def expected_maturity
    if self.species.days_to_maturity
      self.date_planted + self.species.days_to_maturity
    else
      nil
    end
  end

  def set_expected_maturity_date
    binding.pry
    if self.species.days_to_maturity && self.date_planted
      self.expected_maturity_date = self.date_planted + self.species.days_to_maturity
    end
  end

  # def self.get_upcoming_maturities(user_id)
  #   Planting.where("user_id = ?", user_id).select { }
  # end

end
