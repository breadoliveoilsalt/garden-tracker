class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
    #RESEARCH USE OF CALLBACKS


# ---- HERE IS WHAT I HAD ORIGINALLY:

  def new
    binding.pry
    if signed_in?
      flash[:message] = "You have an account already."
      redirect_to user_path(current_user.id)
    else
      @user = User.new
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to user_path(@user.id)
    else
      flash[:message] = "User information incomplete."
      render 'users/new'
    end
  end

  def show
      # Note what was in solution:
        # @message = params[:message] if params[:message]
        # @message ||= false
    if signed_in?
      # @user = User.find_by(id: params[:id])
      # if @user = User.find_by(id: session[:user_id])
      render 'users/show'
    else
      redirect_to root_path
    end
    # else
    #   redirect_to root_path
    # end
  end

# Do I need edit?
  def edit
  end

# Update accordingly
  def update
    attraction = Attraction.find_by(id: params[:attraction_id])
    if logged_in?
      if current_user.height < attraction.min_height &&
        flash[:message] = "You are not tall enough to ride the #{attraction.name}. You do not have enough tickets to ride the #{attraction.name}"
        redirect_to user_path(current_user.id)
      elsif current_user.height < attraction.min_height
        flash[:message] = "You are not tall enough to ride the #{attraction.name}"
        redirect_to user_path(current_user.id)
      elsif current_user.tickets < attraction.tickets
        flash[:message] = "You do not have enough tickets to ride the #{attraction.name}"
        redirect_to user_path(current_user.id)
      else
        current_user.tickets -= attraction.tickets
        current_user.nausea = attraction.nausea_rating
        # binding.pry
        current_user.happiness = attraction.happiness_rating
        current_user.save
        # binding.pry
        flash[:message] = "Thanks for riding the #{attraction.name}!"
        redirect_to user_path(current_user.id)
      end
    else
      redirect_to root_path
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :password)
    end
end
