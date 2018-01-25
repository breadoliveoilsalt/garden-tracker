class Species < ActiveRecord::Base

  validates :name, presence: :true
  validates :type, presence: :true

  has_many :garden_species
  has_many :gardens, through: :garden_species
  has_many :plantings


end
