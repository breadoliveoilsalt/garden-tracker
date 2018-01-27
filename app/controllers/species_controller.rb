class SpeciesController < ApplicationController

  before_action :set_species, only: [:show, :edit, :update, :destroy]
  before_action :check_permission, only: [:show, :edit, :update, :destroy]

  def new
    @species = Species.new
  end

  def create
    @species = current_user.species.build(species_params)
    if @species.save
      redirect_to species_path(@species.id)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @species.update(species_params)
      redirect_to species_path(@species.id)
    else
      render :edit
    end
  end

  def show
  end

  def destroy
    @species.destroy
    # Probably have to destroy each planting that belongs to this species!
    redirect_to user_path(current_user.id)
  end

  private

  def species_params
    params.require(:species).permit(:name, :product, :sunlight)
  end

  def set_species
    @species = Species.find(params[:id])
  end

  def check_permission
    if @species.user.id != current_user.id
      flash[:message] = "Sorry, request denied. That species belongs to another user."
      redirect_to user_path(current_user.id)
    end
  end


end
