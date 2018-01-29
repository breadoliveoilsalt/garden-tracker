class PlantingsController < ApplicationController

  before_action :set_planting, only: [:show, :edit, :update, :destroy]
  before_action :check_permission, only: [:show, :edit, :update, :destroy]

  def new
    @planting = Planting.new
  end

  def create
    @planting = current_user.plantings.build(planting_params)
      # above: have to make sure to link this to both a garden and a species
    if @planting.save
      redirect_to planting_path(@planting.id)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @planting.update(planting_params)
      redirect_to planting_path(@planting.id)
    else
      render :edit
    end
  end

  def show
  end

  def destroy
    @planting.destroy
    #destroy each planting too...but maybe not species
    #Consider the above
    redirect_to user_path(current_user.id)
  end

  private

  def planting_params
    params.require(:planting).permit(:quantity, :garden_id, :species_id, :user_id)
  end

  def set_planting
    @planting = Planting.find(params[:id])
  end

  def check_permission
    if @planting.user.id != current_user.id
      flash[:message] = "Sorry, request denied. That planting belongs to another user."
      redirect_to user_path(current_user.id)
    end
  end

end
