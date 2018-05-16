class SpeciesController < ApplicationController

  before_action :check_if_signed_in
  before_action :set_species, only: [:show, :edit, :update, :destroy]
  before_action :check_permission, only: [:show, :edit, :update, :destroy]

  def new
    @species = Species.new
  end

  def create
    @species = current_user.species.build(species_params)

    respond_to do |format|
      format.html { render :show }
      format.json { render_species_json(@species) }
    end

    # Proior language that worked:

    # @species = current_user.species.build(species_params)
    # if @species.save
    #   render json: @species, status: 201
    # else
    #   render :json => {:errors => @species.errors.full_messages}, status: 422
    # end

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
    respond_to do |format|
      format.html { render :show }
      format.json { render json: @species }
    end
  end

  def destroy
    destroy_associated_plantings(@species)
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
      flash[:message] = "Sorry, that species belongs to another user."
      redirect_to user_path(current_user.id)
    end
  end

  def destroy_associated_SpeciesGarden_entries
    SpeciesGarden.where(species_id: @species.id).destroy_all
  end

  def render_species_json(obj)
    if obj.save
      render json: obj, status: 201
    else
      render :json => {:errors => obj.errors.full_messages}, status: 422
    end
  end

end
