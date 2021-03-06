class GardenSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :square_feet, :user_id, :active

  belongs_to :user
  has_many :species
  has_many :plantings
end
