class UsersController < ApplicationController

  before_action :check_if_signed_in, only: [:show]

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
      @active_gardens = Garden.get_active_gardens(current_user.id)
    else
      flash[:message] = "Please sign in or create an account."
      redirect_to root_path
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :password)
    end

    def current_user_show_page
      current_user.id == params[:id].to_i
    end

end
