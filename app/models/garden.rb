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

      # When creating a new garden and mass assignment jumps to this method,
      # the garden (parent of planting) has to be saved first or else there
      # will be an error when trying to create the associated planting in this method:
    if self.save

        # Need to specify ".values" because, thanks to the has_nested_attributes_for
        # macro, the format looks like [plantings_attributes][0][hash_of_attributes].
        # So .values is used to run just the hash_of_attributes through the methods below:
      planting_attributes_hash.values.each do | planting_attributes |

          # A planting should only be created or edited if a quantity is specified. There
          # will always be a "product" due to the drop down menu, so [:product] is not the
          # relevant critereon for whether a user meant to create or update a planting:

          # First, check if we are creating a new garden and creating a new planting with it.
          # This will be the case if the user has filled in something for [:quantity]
          # and the planting does not have an [:id] yet because the planting has not been persisted:
        if planting_attributes[:quantity] != "" && !planting_attributes[:id]
          planting = self.plantings.build(planting_attributes)
          planting.save

          # Second, check if we are editing a planting.  This will be the case if the plantings
          # has an [:id] that was passed into params by rails (in an autogenerated hidden field):
        elsif planting_attributes[:id]
          planting = Planting.find_by(id: planting_attributes[:id])
          planting.update(planting_attributes)
        end
      end
    end
  end
    # binding.pry # The update function is not calling this!! #It's b/c I forgot that it's plantingS_attributes, not planting_attributes, when i custom wrote it.

    # This worked with #new in the full accepts_nested_attributes regime.
    # if self.save
    #   planting_attributes_hash.values.each do | planting_attributes |
    #     if planting_attributes[:quantity] != ""
    #       planting = self.plantings.build(planting_attributes)
    #       planting.save
    #     end
    #   end
    # end


        # if planting_attribute[:quantity] != ""
    # This is what I originally had when planting_attributes was at the top of the fields for
    # if self.save && planting_attributes_hash[:quantity] != ""
    #     planting = self.plantings.build(planting_attributes_hash)
    #     planting.save
    # end

  def update_garden_nested_form(garden_params)
  end



end
