class PlantingsController < ApplicationController

  before_action :set_planting, only: [:update, :destroy] #:show, :edit,
  before_action :check_permission, only: [:update, :destroy] #:show, :edit,
    # above: need to think how check_permission interacts with nexted resources


  def new
    @garden = Garden.find_by(id: params[:garden_id])
    @planting = Planting.new
  end

  def create
    binding.pry
    @planting = current_user.plantings.build(planting_params)
      # above: have to make sure to link this to both a garden and a species
    if @planting.save
      redirect_to user_garden_path(current_user.id, @planting.garden.id)
    else
      render :new
    end
  end

  # def edit
  # end

  def update
    if @planting.update(planting_params)
      redirect_to planting_path(@planting.id)
    else
      render :edit
    end
  end
  #
  # def show
  # end

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

  # def check_garden_permission
  #   if @garden == nil || @garden.user.id != current_user.id
  #     flash[:message] = "Sorry, request denied. You do not have permission to view that garden."
  #     redirect_to user_path(current_user.id)
  #   end
  # end

end
