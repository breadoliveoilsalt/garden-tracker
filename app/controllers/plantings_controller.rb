class PlantingsController < ApplicationController

  before_action :set_planting, only: [:show, :edit, :update, :destroy]
  before_action :check_permission, only: [:show, :edit, :update, :destroy]
    # above: need to think how check_permission interacts with nexted resources


  def index
    if params[:garden_id]
      @garden = Garden.find_by(id: params[:garden_id])
      # check_garden_permission # this would not work for some reason -- would not redirect, would just come back here, even though it was definitely jumping to the method
      if @garden == nil || @garden.user.id != current_user.id
        flash[:message] = "Sorry, request denied. You do not have permission to view that garden."
        redirect_to user_path(current_user.id)
      else
        @plantings = @garden.plantings
      end
    else
      @plantings = current_user.plantings
    end
  end

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

  # def check_garden_permission
  #   if @garden == nil || @garden.user.id != current_user.id
  #     flash[:message] = "Sorry, request denied. You do not have permission to view that garden."
  #     redirect_to user_path(current_user.id)
  #   end
  # end

end
