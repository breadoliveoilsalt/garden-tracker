class UserSerializer < ActiveModel::Serializer
  attributes :id, :name

  has_many :gardens
  has_many :species
  has_many :plantings
end
