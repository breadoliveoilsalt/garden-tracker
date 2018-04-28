class GardenSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :square_feet, :user_id
end
