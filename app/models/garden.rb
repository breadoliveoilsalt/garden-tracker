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
    planting = self.plantings.build(planting_attributes_hash)
    binding.pry
  end
end


# def categories_attributes=(category_attributes)
#     category_attributes.values.each do |category_attribute|
#       category = Category.find_or_create_by(category_attribute)
#       self.categories << category
#     end
