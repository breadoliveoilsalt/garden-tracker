class GardenSpecies < ActiveRecord::Base

  validates :garden_id, numericality: {only_integer: true}
  validates :species_id, numericality: {only_integer: true}
end
