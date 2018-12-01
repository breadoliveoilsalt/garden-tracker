class PlantingSerializer < ActiveModel::Serializer
  attributes :id, :quantity, :garden_id, :species_id, :user_id, :name, :date_planted, :date_harvested, :expected_maturity_date

  belongs_to :user
  belongs_to :garden
  belongs_to :species
end
