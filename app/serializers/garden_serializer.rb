class GardenSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :square_feet, :user_id

  belongs_to :user
  # has_many :species_garden
  has_many :species
    # , through: :species_garden
  has_many :plantings
end
