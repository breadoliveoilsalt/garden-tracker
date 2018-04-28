class SpeciesSerializer < ActiveModel::Serializer
  attributes :id, :name, :product, :sunlight, :user_id

  belongs_to :user
  # has_many :species_garden
  has_many :gardens
    # , through: :species_garden
  has_many :plantings
end
