class Planting < ActiveRecord::Base

  validates :quantity, presence: true, numericality: {only_integer: true, greater_than: 0}
  validates :garden_id, presence: true, numericality: {only_integer: true}
  validates :species_id, presence: true, numericality: {only_integer: true}

  belongs_to :garden
  belongs_to :species

end
