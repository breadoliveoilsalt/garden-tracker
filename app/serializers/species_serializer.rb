class SpeciesSerializer < ActiveModel::Serializer
  attributes :id, :name, :product, :sunlight, :user_id
  
end
