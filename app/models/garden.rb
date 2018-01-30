class Garden < ActiveRecord::Base

  validates :name, presence: true
  validates :square_feet, numericality: {only_integer: true, message: "must be a whole number"}, allow_nil: true
  validates :user_id, presence: true, numericality: {only_integer: true}

  belongs_to :user
  has_many :species_garden
  has_many :species, through: :species_garden
  has_many :plantings

  accepts_nested_attributes_for :plantings

  def planting_attributes=(planting_attributes_hash)
    if self.save && planting_attributes_hash[:quantity] != ""
        planting = self.plantings.build(planting_attributes_hash)
        planting.save
    end
  end


end
