class Garden < ActiveRecord::Base

  validates :name, presence: :true
  validates :square_feet, numericality: {only_integer: true}

  has_many :garden_species
  has_many :species, through: :garden_species
  has_many :plantings

end
