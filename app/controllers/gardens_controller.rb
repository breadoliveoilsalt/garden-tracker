class GardensController < ApplicationController

  before_action :check_if_signed_in
  before_action :set_garden, only: [:show, :edit, :update, :destroy]
  before_action -> { check_permission(@garden) }, only: [:show, :edit, :update, :destroy]

  def index
    @active_gardens = Garden.get_active_gardens(current_user.id)
    @inactive_gardens = Garden.get_inactive_gardens(current_user.id)
  end

  def new
    @garden = Garden.new
  end

  def create
    @garden = current_user.gardens.build(garden_params)
    if @garden.save
      flash[:message] = "#{@garden.name} was added to your list of gardens."
      redirect_to user_garden_path(current_user.id, @garden.id)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @garden.update(garden_params)
      flash[:message] = "#{@garden.name} was updated."
      redirect_to user_garden_path(current_user.id, @garden.id)
    else
      render :edit
    end
  end

  def show
  end

  def destroy
    destroy_associated_plantings(@garden)
    destroy_associated_SpeciesGarden_entries
    @garden.destroy
    flash[:message] = "#{@garden.name} was deleted from your list of gardens."
    redirect_to user_path(current_user.id)
  end

  def next
    user = User.find_by(id: params[:user_id])
    garden = user.gardens.where("id > ?", params[:garden_id]).first
    if garden
      render json: garden
    else
      render json: user.gardens.first
    end
  end

  def previous
    user = User.find_by(id: params[:user_id])
    garden = user.gardens.where("id < ?", params[:garden_id]).last
    if garden
      render json: garden
    else
      render json: user.gardens.last
    end
  end

  private

  def garden_params
    params.require(:garden).permit(:name, :active, :square_feet, :description, plantings_attributes:[:id, :species_id, :quantity, :user_id, :date_planted, :date_harvested, :expected_maturity_date])
  end

  def set_garden
    @garden = Garden.find_by(id: params[:id])
  end

  def destroy_associated_SpeciesGarden_entries
    SpeciesGarden.where(garden_id: @garden.id).destroy_all
  end

end
