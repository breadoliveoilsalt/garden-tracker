class SpeciesController < ApplicationController

  before_action :check_if_signed_in
  before_action :set_species, only: [:show, :edit, :update, :destroy]
  before_action -> { check_permission(@species)} , only: [:show, :edit, :update, :destroy]

  def index
    @species = current_user.species
  end

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
    # respond_to do |format|
    #   format.html { render :show }
    #   format.json { render json: @species }
    # end
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
    params.require(:species).permit(:name, :product, :sunlight, :days_to_maturity)
  end

  def set_species
    @species = Species.find_by(id: params[:id])
  end

  # def check_permission
  #   if params[:user_id].to_i != current_user.id
  #     flash[:message] = "Sorry, the page you are looking for belongs to another user."
  #     redirect_to user_path(current_user.id)
  #   elsif !@species
  #     flash[:message] = "Sorry, the page you are looking for does not appear to exist."
  #     redirect_to user_path(current_user.id)
  #   elsif @species.user.id != current_user.id
  #    flash[:message] = "Sorry, the page you are looking for belongs to another user."
  #    redirect_to user_path(current_user.id)
  #   end
  # end

  def destroy_associated_SpeciesGarden_entries
    SpeciesGarden.where(species_id: @species.id).destroy_all
  end

end
