class PlantingSerializer < ActiveModel::Serializer
  attributes :id, :quantity, :garden_id, :species_id, :user_id
  
  belongs_to :user
  belongs_to :garden
  belongs_to :species
end
