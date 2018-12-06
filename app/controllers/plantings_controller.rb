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
      @planting.garden.species << @planting.species
      flash[:message] = "#{@planting.name} added to #{@planting.garden.name}."
      redirect_to edit_user_garden_path(current_user.id, @planting.garden_id)
    else
      set_garden
      render :new
    end
  end

  def destroy
    @planting.destroy
    flash[:message] = "#{@planting.species.name} planting deleted."
    redirect_to edit_user_garden_path(current_user.id, @planting.garden_id)
  end

  private

  def planting_params
    params.require(:planting).permit(:quantity, :garden_id, :species_id, :user_id)
  end

  def set_planting
    @planting = Planting.find_by(id: params[:id])
  end

  def set_garden
    @garden = Garden.find_by(id: params[:garden_id])
  end

end
