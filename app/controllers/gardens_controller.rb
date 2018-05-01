class GardensController < ApplicationController

  before_action :check_if_signed_in
  before_action :set_garden, only: [:show, :edit, :update, :destroy]
  before_action :check_permission, only: [:edit, :update, :destroy]

  def new
    @garden = Garden.new
  end

  def create
      # Some of the patterning under #create is a bit non-standard.  This was done to ensure
      # that when a new garden is created, errors appear when non-valid data appears in the
      # nested form for plantings. README_gardens_controller_with_explanations walks through
      # the choices here and explains them.
    @garden = Garden.create(garden_params)
    if @garden.id && @garden.errors.details != {}
      @garden.destroy
      render :new
    elsif @garden.errors.details != {}
      render :new
    else
      flash[:message] = "#{@garden.name} was added to your list of gardens."
      redirect_to garden_path(@garden.id)
    end
  end

  def edit
  end

  def update
      # The logic here was done to ensure that errors appear when non-valid data is submitted
      # in a nested edit form.  See README_gardens_controller_with_explanations for explanations.
    if !garden_params[:plantings_attributes]
      @garden.update(garden_params)
      test_update_and_redirect
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

        # Check if the user id in the url is valid and if the garden specified (and set by #set_garden)
        # belongs to the user specified in the url. If yes to all, render the show page:
      @user = User.find_by(id: params[:user_id])
      if @user && @user.gardens.include?(@garden)
        respond_to do |format|
          format.html { render :show }
          format.json { render json: @garden }
        end

       # render :show
      else
       flash[:message] = "Sorry, user or garden does not exist."
       redirect_to user_path(current_user.id)
      end

        # If not a nested route, check that #set_garden has identified an existing
        # garden and show that garden if so:
    elsif @garden
      respond_to do |format|
        format.html { render :show }
        format.json { render json: @garden }
      end

      # render :show
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

  def largest
    @garden = Garden.largest_garden
    if @garden == nil
      flash[:message] = "Sorry, no gardens have been created yet."
      redirect_to redirect_to user_path(current_user.id)
    else
      flash[:message] = "This is currently the largest garden:"
      redirect_to garden_path(@garden.id)
    end
  end

  def most_plantings
    @garden = Garden.garden_with_most_plantings
    if @garden == nil
      flash[:message] = "Sorry, no gardens have been created yet."
      redirect_to redirect_to user_path(current_user.id)
    else
      flash[:message] = "This is currently the garden with the most plantings:"
      redirect_to garden_path(@garden.id)
    end
  end

  def get_garden_ids
    garden_ids = Garden.get_garden_ids_by_user_id(params[:id])
    render json: garden_ids.to_json
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
