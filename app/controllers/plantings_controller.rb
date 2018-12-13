class PlantingsController < ApplicationController

  before_action :check_if_signed_in
  before_action :set_planting, only: [:destroy]
  before_action -> { check_permission(@planting) }, only: [:destroy]

  def new
    set_garden
    @planting = Planting.new
  end

  def create
    @planting = current_user.plantings.build(planting_params)
    if @planting.save
        # Confirmed - I do need this next line:
      if !(@planting.garden.species.include?(@planting.species))
        @planting.garden.species << @planting.species
      end
      flash[:message] = "#{@planting.name} added to #{@planting.garden.name}."
      redirect_to edit_user_garden_path(current_user.id, @planting.garden_id)
    else
      set_garden
      render :new
    end
  end

  def destroy
    @planting.destroy
    check_garden_for_species_removal
    flash[:message] = "#{@planting.species.name} planting deleted."
    redirect_to edit_user_garden_path(current_user.id, @planting.garden_id)
  end

  private

  def planting_params
    params.require(:planting).permit(:quantity, :garden_id, :species_id, :user_id, :date_planted, :date_harvested)
  end

  def set_planting
    @planting = Planting.find_by(id: params[:id])
  end

  def set_garden
    @garden = Garden.find_by(id: params[:garden_id])
  end

  def check_garden_for_species_removal
      # If, after deleting the planting, the garden has no further plantings of
      # the same species, then remove the species from the garden's list of
      # species.
    associated_garden = @planting.garden
    associated_species_id = @planting.species_id

      # Short curcuit the function, returning true, if any of the plantings in
      # the associated_garden have the associated species.
    associated_garden.plantings.each do | planting |
      if planting.species_id == associated_species_id
        return true
      end
    end

      # Otherwise, remove the species from the garden.
    join_table_record = SpeciesGarden.where("garden_id = ? AND species_id = ?", associated_garden.id, associated_species_id)[0]
    SpeciesGarden.destroy(join_table_record.id)

  end

end
