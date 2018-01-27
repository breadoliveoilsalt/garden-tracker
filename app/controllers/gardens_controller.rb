class GardensController < ApplicationController

  before_action :set_garden, only: [:show, :edit, :update, :destroy]
  before_action :check_permission, only: [:show, :edit, :update, :destroy]
# need a call back before each to make sure user is logged in and it is his or her stuff
# you are allowed to look at.  Or else redirect with a flash message.


# TN: remember to set callbacks -- eg before edit and show.  Need edit one b/c of partial that is rendered in edit View

  def new
    @garden = Garden.new
  end

  def create
    @garden = current_user.gardens.build(garden_params)
    if @garden.save
      redirect_to garden_path(@garden.id)
    else
      render :new # 'gardens/new' # I can probably just do render :new
    end
  end

  def edit
  end

  def update
    if @garden.update(garden_params)
      redirect_to garden_path(@garden.id)
    else
      render :edit
    end
  end

  def show
    #@garden = Garden.find_by(id: params[:id])
  end

  def destroy
    @garden.destroy
    #destroy each planting too...but maybe not species
    redirect_to user_path(current_user.id)
  end

  private

  def garden_params
    params.require(:garden).permit(:name, :description, :square_feet)
  end

  def set_garden
    @garden = Garden.find(params[:id])
  end

  def check_permission
    if @garden.user.id != current_user.id
      flash[:message] = "Sorry, request denied.  That garden belongs to another user."
      redirect_to user_path(current_user.id)
    end
  end
  
end
