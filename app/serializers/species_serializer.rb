class SpeciesSerializer < ActiveModel::Serializer
  attributes :id, :name, :product, :sunlight, :user_id

  belongs_to :user
  has_many :gardens
  has_many :plantings
end
