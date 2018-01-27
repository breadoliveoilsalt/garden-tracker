class GardensController < ApplicationController

# need a call back before each to make sure user is logged in and it is his or her stuff
# you are allowed to look at.  Or else redirect with a flash message.

  def new
    @garden = Garden.new
  end

  def create
    @garden = current_user.gardens.build(garden_params)
    if @garden.save
      redirect_to garden_path(@garden.id)
    else
      render 'gardens/new'
    end
  end

  def show
    @garden = Garden.find_by(id: params[:id])
  end


  private

  def garden_params
    params.require(:garden).permit(:name, :description, :square_feet)
  end

end
