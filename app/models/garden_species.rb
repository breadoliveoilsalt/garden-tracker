class GardenSpecies < ActiveRecord::Base

  validates :garden_id, presence: true, numericality: {only_integer: true}
  validates :species_id, presence: true, numericality: {only_integer: true}
end
