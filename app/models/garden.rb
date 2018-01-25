class Garden
  validates :name, presence: :true

  has_many :garden_species
  has_many :species
  has_many :plantings
  
end
