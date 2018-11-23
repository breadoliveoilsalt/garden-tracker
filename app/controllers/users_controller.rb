class UsersController < ApplicationController

  before_action :check_if_signed_in, only: [:show]
  before_action :set_user, only: [:show]

  def new
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
      render :new
    end
  end

  def show
    if signed_in?
      @active_gardens = Garden.get_active_gardens(@user.id)
    else
      flash[:message] = "Please sign in or create an account."
      redirect_to root_path
    end
  end
    #
    #   # Only allow current_user to see its own show page.
    #   # A user's user/show page effecitvely serves as the user's gardens/index and species/index pages.
    # if signed_in? && current_user_show_page
    #   @other_users = User.all_except(current_user)
    #   render :show
    #
    #   # If user is signed in but trying to view another user's show page, redirect
    #   # to its own show page with flash message
    # elsif signed_in? && !current_user_show_page
    #   flash[:message] = "Sorry, you do not have permission to view that user's profile."
    #   redirect_to user_path(current_user.id)
    #
    #   # Otherwise, direct user to welcome page.
    # else
    #   flash[:message] = "Please sign in or create an account."
    #   redirect_to root_path
    # end

  private

    # def set_user
    #   @user = current_user
    # end

    def user_params
      params.require(:user).permit(:name, :password)
    end

    def current_user_show_page
      current_user.id == params[:id].to_i
    end
end
