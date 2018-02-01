class GardensController < ApplicationController

  before_action :set_garden, only: [:show, :edit, :update, :destroy]
  before_action :check_permission, only: [:edit, :update, :destroy]

  def new
    @garden = Garden.new
  end

  def create
      # Garden.new does not appear to generate an error object when nested form is invalid,
      # so went with Garden.create

      # Note on the next line that when mass assignment runs through garden_params and gets
      # to the custom writer (Garden.plantings_attributes=), the custom writer must save
      # the garden instance that was just created, or there will be errors persisting the
      # associated child (plantings).  This leads in part to the complications below:
    @garden = Garden.create(garden_params)

      # If the garden instance was successfully persisted through the custom writer
      # (and so has an id), but if there
      # are still errors associated with the instance (because there was something wrong
      # with the nested form form for plantings), then destroy the garden that was just created
      # and go back to the new form.  If the last garden is not destroyed, a user could create
      # two instances of gardens with the same name after re-submitting the form:
    if @garden.id && @garden.errors.details != {}
      @garden.destroy
      render :new

      # If there are otherwise errors (due to invalid information for the garden instance, resulting
      # in the garden instance not being persisted), then go back to the new form as well:
    elsif @garden.errors.details != {}
      render :new

      # If there are no errors, then go to the garden show page:
    else #@garden.save
      redirect_to garden_path(@garden.id)
    end
  end

  def edit

  end

  def update
    @garden.update(garden_params)
    if @garden.valid?
      redirect_to garden_path(@garden.id)
    else
      render :edit
    end
  end

  def index
    if params[:user_id] # Check if the route is a nested route, such as users/1/gardens
      if @user = User.find_by(id: params[:user_id]) # See if user id params is valid, and if so, define @gardens
        @gardens = @user.gardens
      else
        flash[:message] = "Sorry, user does not exist."
        redirect_to user_path(current_user.id)
      end
    else # If not a nested route, show all the gardens
      @gardens = Garden.all
    end
  end

  def show

        # Check if the route is a nested route, such as users/1/gardens/1
    if params[:user_id]

        # See if the user id in the url is valid and if the garden specified (and set by #set_garden)
        # belongs to the user specified in the url. If yes to all, render the show page:
      @user = User.find_by(id: params[:user_id])
      if @user && @user.gardens.include?(@garden)
       render 'gardens/show'
      else
       flash[:message] = "Sorry, user or garden does not exist."
       redirect_to user_path(current_user.id)
      end

      # If not a nested route, check that #set_garden has identified an existing
      # garden and show that garden if so:
    elsif @garden
      render 'gardens/show'
    else
       flash[:message] = "Sorry, garden does not exist."
       redirect_to user_path(current_user.id)
     end
   end


  def destroy
    destroy_associated_plantings
    destroy_associated_SpeciesGarden_entries
    @garden.destroy
    flash[:message] = "#{@garden.name} was deleted from your list of gardens."
    redirect_to user_path(current_user.id)
  end

  private

  def garden_params
    params.require(:garden).permit(:name, :description, :square_feet, :user_id, plantings_attributes:[:id, :species_id, :quantity, :user_id])
  end

  def set_garden
    @garden = Garden.find_by(id: params[:id])
  end

  def check_permission
    if @garden.user.id != current_user.id
      flash[:message] = "Sorry, request denied. That garden belongs to another user."
      redirect_to user_path(current_user.id)
    end
  end

  def destroy_associated_plantings #can probably dry this up in application controller with SpeciesController
    @garden.plantings.each do |planting|
      planting.destroy
    end
  end

  def destroy_associated_SpeciesGarden_entries
    SpeciesGarden.where(garden_id: @garden.id).destroy_all
  end

end
