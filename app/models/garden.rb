class Garden < ActiveRecord::Base

  validates :name, presence: true
  validates :square_feet, numericality: {only_integer: true, message: "must be a whole number"}, allow_nil: true
  validates :user_id, presence: true, numericality: {only_integer: true}

  belongs_to :user
  has_many :species_garden
  has_many :species, through: :species_garden
  has_many :plantings

  accepts_nested_attributes_for :plantings
  # They probably want me to use something like this if the quantity is blank:
    #  accepts_nested_attributes_for :tags, reject_if: proc { |attributes| attributes['name'].blank? }
    # from rails-blog-nested-forms (mine)

  def plantings_attributes=(planting_attributes_hash)
    # binding.pry # The update function is not calling this!! #It's b/c I forgot that it's plantingS_attributes, not planting_attributes, when i custom wrote it.
    if self.save
      planting_attributes_hash.values.each do | planting_attributes |
        if planting_attributes[:quantity] != ""
          planting = self.plantings.build(planting_attributes)
          planting.save
        end
      end
    end
  end
        # if planting_attribute[:quantity] != ""
    # This is what I originally had when planting_attributes was at the top of the fields for
    # if self.save && planting_attributes_hash[:quantity] != ""
    #     planting = self.plantings.build(planting_attributes_hash)
    #     planting.save
    # end



end
