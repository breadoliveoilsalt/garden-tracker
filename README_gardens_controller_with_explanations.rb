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
    else
      flash[:message] = "#{@garden.name} was added to your list of gardens."
      redirect_to garden_path(@garden.id)
    end
  end

  def edit

  end

  def update
      # If garden_params do not include planting_attributes data (because
      # there have been no prior plantings), then use normal AR #update:
    if !garden_params[:plantings_attributes]
      @garden.update(garden_params)
      test_update_and_redirect

      # If garden_params include planting_attributes data, then user
      # custom updater, which was needed to ensure that any error messages about
      # the nested forms appear:
    else
      @garden.custom_updater_for_nested_params(garden_params)
      test_update_and_redirect
    end
  end

  def index

       # Check if the url is a nested url, such as users/1/gardens:
    if params[:user_id]

        # See if user id params is valid, and if so, define @gardens:
      if @user = User.find_by(id: params[:user_id])
        @gardens = @user.gardens
      else
        flash[:message] = "Sorry, user does not exist."
        redirect_to user_path(current_user.id)
      end

        # If the url is not a nested url, show all the gardens:
    else
      @gardens = Garden.all
    end
  end

  def show

        # Check if the route is a nested url, such as users/1/gardens/1
    if params[:user_id]

        # See if the user id in the url is valid and if the garden specified (and set by #set_garden)
        # belongs to the user specified in the url. If yes to all, render the show page:
      @user = User.find_by(id: params[:user_id])
      if @user && @user.gardens.include?(@garden)
       render :show
      else
       flash[:message] = "Sorry, user or garden does not exist."
       redirect_to user_path(current_user.id)
      end

        # If not a nested route, check that #set_garden has identified an existing
        # garden and show that garden if so:
    elsif @garden
      render :show
    else
       flash[:message] = "Sorry, garden does not exist."
       redirect_to user_path(current_user.id)
     end
   end


  def destroy
    destroy_associated_plantings(@garden)
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

  def destroy_associated_SpeciesGarden_entries
    SpeciesGarden.where(garden_id: @garden.id).destroy_all
  end

  def test_update_and_redirect
    if @garden.errors.messages != {}
      render :edit
    else
      flash[:message] = "#{@garden.name} was updated."
      redirect_to garden_path(@garden.id)
    end
  end

end
