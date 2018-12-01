class SpeciesSerializer < ActiveModel::Serializer
  attributes :id, :name, :category, :sunlight, :user_id, :days_to_maturity

  belongs_to :user
  has_many :gardens
  has_many :plantings
end
