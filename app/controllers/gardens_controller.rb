class GardensController < ApplicationController

  before_action :set_garden, only: [:show, :edit, :update, :destroy]
  before_action :check_permission, only: [:edit, :update, :destroy]

  def new
    @garden = Garden.new
  end

  def create
      # Garden.new does not appear to generate an error object if nested form is invalid,
      # so went with Garden.create

      # When mass assignment runs through garden_params and gets to the custom writer
      # Garden.plantings_attributes=, the custom writer must save


    @garden = Garden.create(garden_params)

      # If the garden instance was successfully created (and so has an id) but if there
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
    elsif #@garden.save
      redirect_to garden_path(@garden.id)
    end

  end
    # binding.pry
    # if @garden.save
    #   redirect_to garden_path(@garden.id)
    #   else
    #     binding.pry
    #     render :new
    #   end
    # # @garden = Garden.create(garden_params)
    # if @garden.valid?
    #   redirect_to garden_path(@garden.id)
    #   else
    #     binding.pry
    #     render :new
    #   end
  #end

  def edit

  end

  def update
    @garden.update(garden_params)
    binding.pry
    if @garden.valid?
      binding.pry
      redirect_to garden_path(@garden.id)
    else
      render :edit
    end
    # Next, see if the pry tells me the errors
    # if @garden.update(garden_params)
    #   binding.pry
    #   redirect_to garden_path(@garden.id)
    # else
    #   render :edit
    # end
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
    if params[:user_id] # Check if the route is a nested route, such as users/1/gardens/1
          # See if the user id params is valid and if the garden specified (and set by #set_garden)
          # belongs to the user. If yes to all, render the show page:
      @user = User.find_by(id: params[:user_id])
      if @user && @user.gardens.include?(@garden)
       render 'gardens/show'
      else
       flash[:message] = "Sorry, user or garden does not exist."
       redirect_to user_path(current_user.id)
      end
    elsif @garden # if not a nested route, check that #set_garden has identified an existing garden and show that garden if so
      render 'gardens/show'
    else
       flash[:message] = "Sorry, garden does not exist."
       redirect_to user_path(current_user.id)
     end
   end
  #     # check_garden_permission # this would not work for some reason -- would not redirect, would just come back here, even though it was definitely jumping to the method
  #     if @garden == nil || @garde.user.id != current_user.id
  #       flash[:message] = "Sorry, request denied. You do not have permission to view that garden."
  #       redirect_to user_path(current_user.id)
  #     else
  #
  #     end
  #   else
  #     @plantings = current_user.plantings
  #   end
  # end

  def destroy
    @garden.destroy
    #destroy each planting too...but maybe not species
    #Consider the above
    redirect_to user_path(current_user.id)
  end

  private

  def garden_params
    params.require(:garden).permit(:name, :description, :square_feet, :user_id, plantings_attributes:[:id, :species_id, :quantity, :user_id])
    # This is what I had to get new form to work.  Have to modify it b/c otherwise cant use with has_nested_attributes
    # params.require(:garden).permit(:name, :description, :square_feet, :user_id, planting_attributes: [:species_id, :quantity, :user_id])
  end

  def set_garden
    @garden = Garden.find(params[:id])
  end

  def check_permission
    if @garden.user.id != current_user.id
      flash[:message] = "Sorry, request denied. That garden belongs to another user."
      redirect_to user_path(current_user.id)
    end
  end


end
