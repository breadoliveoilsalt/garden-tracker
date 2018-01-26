class SpeciesGarden < ActiveRecord::Base

  validates :species_id, presence: true, numericality: {only_integer: true}
  validates :garden_id, presence: true, numericality: {only_integer: true}

  belongs_to :garden
  belongs_to :species

end
