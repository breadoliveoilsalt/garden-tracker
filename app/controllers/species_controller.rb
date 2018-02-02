class SpeciesController < ApplicationController

  before_action :set_species, only: [:show, :edit, :update, :destroy]
  before_action :check_permission, only: [:show, :edit, :update, :destroy]

  def new
    @species = Species.new
  end

  def create
    @species = current_user.species.build(species_params)
    if @species.save
      flash[:message] = "#{@species.name} was added to your list of species."
      redirect_to user_species_path(current_user.id, @species.id)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @species.update(species_params)
      flash[:message] = "#{@species.name} was updated."
      redirect_to user_species_path(current_user.id, @species.id)
    else
      render :edit
    end
  end

  def show
  end

  def destroy
    destroy_assocated_plantings
    destroy_associated_SpeciesGarden_entries
    @species.destroy
    flash[:message] = "The species #{@species.name} was deleted from your species list."
    redirect_to user_path(current_user.id)
  end

  private

  def species_params
    params.require(:species).permit(:name, :product, :sunlight)
  end

  def set_species
    @species = Species.find_by(id: params[:id])
  end

  def check_permission
    if !@species || @species.user.id != current_user.id
      flash[:message] = "Sorry, request denied."
      redirect_to user_path(current_user.id)
    end
  end

  def destroy_assocated_plantings
    @species.plantings.each do |planting|
      planting.destroy
    end
  end

  def destroy_associated_SpeciesGarden_entries
    SpeciesGarden.where(species_id: @species.id).destroy_all
  end

end
