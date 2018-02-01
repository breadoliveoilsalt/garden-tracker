class PlantingsController < ApplicationController

  before_action :set_planting, only: [:update, :destroy] #:show, :edit,
  before_action :check_permission, only: [:update, :destroy] #:show, :edit,
    # above: need to think how check_permission interacts with nexted resources


  def new
    set_garden
    @planting = Planting.new
  end

  def create
    @planting = current_user.plantings.build(planting_params)
    if @planting.save
      @planting.garden.species << @planting.species
      flash[:message] = "#{@planting.name} added to #{@planting.garden.name}."
      redirect_to user_garden_path(current_user.id, @planting.garden.id)
    else
      set_garden
      render :new
    end
  end

  def destroy
    @planting.destroy
    flash[:message] = "#{@planting.species.name} planting deleted."
    redirect_to garden_path(@planting.garden.id)
  end

  private

  def planting_params
    params.require(:planting).permit(:quantity, :garden_id, :species_id, :user_id)
  end

  def set_planting
    @planting = Planting.find_by(id: params[:id])
  end

  def check_permission
    if @planting.user.id != current_user.id
      flash[:message] = "Sorry, request denied. That planting belongs to another user."
      redirect_to user_path(current_user.id)
    end
  end

  def set_garden
    @garden = Garden.find_by(id: params[:garden_id])
  end

end
