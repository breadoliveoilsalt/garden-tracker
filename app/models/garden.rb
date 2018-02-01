class Garden < ActiveRecord::Base

  validates :name, presence: true
  validates :square_feet, numericality: {only_integer: true, message: "must be a whole number"}, allow_nil: true
  validates :user_id, presence: true, numericality: {only_integer: true}

  belongs_to :user
  has_many :species_garden
  has_many :species, through: :species_garden
  has_many :plantings

  accepts_nested_attributes_for :plantings

  def plantings_attributes=(plantings_attributes_hash)

      # When creating a new garden and mass assignment jumps to this method,
      # the garden (parent of planting/self) has to be saved first or else there
      # will be an error when trying to create the associated planting in this method.
      # In other words, even though this is triggered by Garden.create, the garden
      # instance is not saved yet with an id at this point in the middle of .create,
      # and so we need to save it here to create the child (planting):
    if self.save

        # Need to specify ".values" thanks to the formatting of the has_nested_attributes_for
        # macro (ie, [plantings_attributes][0][hash_of_attributes]):
      plantings_attributes_hash.values.each do | planting_attributes |

          # Check if :quantity is not empty, because that means the user intended to
          # establish a planting when first creating the garden:
        if !planting_attributes[:quantity].empty?
          planting = self.plantings.build(planting_attributes)

          if planting.save # Need to check if savable in case, say, there were no species created yet.
            planting.garden.species << planting.species # Need this to make sure SpeciesGarden join table is populated
          end

        end
      end
    end
  end

    # Custom updater was needed because errors with the nested form would not show up
    # if plain old .update(gardens_params) was called and ran through planting_attributes=
  def custom_nested_updater(garden_params)
    self.name = garden_params[:name]
    self.description = garden_params[:description]
    self.square_feet = garden_params[:square_feet]
    if self.save
      garden_params[:plantings_attributes].values.each do | planting_attributes |
        planting = self.plantings.find_by(id: planting_attributes[:id]) # Consider cleaning up without the self
        planting.species_id = planting_attributes[:species_id]
        planting.quantity = planting_attributes[:quantity]
        planting.save
        if planting.errors.messages != {}
          self.errors[:base] << "Errors with the #{planting.name} planting: #{planting.errors.full_messages.join(". ")}."
        end
      end
    end
  end


end
