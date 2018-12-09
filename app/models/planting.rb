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

  def valid_date_planted?
    binding.pry
    begin
      Date.parse(self.date_planted_before_type_cast)
    rescue
      self.errors.add(:date_planted, "for #{self.name} is not a valid date")
    end
  end

  def valid_date_harvested?
    if self.date_harvested_before_type_cast

        # short circuit as ok if form has "", meaning date was not entered
      return true if self.date_harvested_before_type_cast == ""

      begin
        Date.parse(self.date_harvested_before_type_cast)
      rescue
        self.errors.add(:date_harvested, "for #{self.name} is not a valid date")
      end
    end
  end

  def name
    self.species.name
  end

  def set_expected_maturity_date
    if self.species.days_to_maturity && self.date_planted
      self.expected_maturity_date = self.date_planted + self.species.days_to_maturity
    end
  end

end
