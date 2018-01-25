class Garden < ActiveRecord::Base

  validates :name, presence: :true

  has_many :garden_species
  has_many :species, through: :garden_species
  has_many :plantings

end
