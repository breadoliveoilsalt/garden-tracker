class Garden < ActiveRecord::Base

  validates :name, presence: true
  validates :square_feet, numericality: {only_integer: true}

  belongs_to :user
  has_many :garden_species
  has_many :species, through: :garden_species
  has_many :plantings

end
