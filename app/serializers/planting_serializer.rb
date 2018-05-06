class PlantingSerializer < ActiveModel::Serializer
  attributes :id, :quantity, :garden_id, :species_id, :user_id, :name

  belongs_to :user
  belongs_to :garden
  belongs_to :species
end
