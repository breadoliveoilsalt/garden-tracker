class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception


  private

  helper_method :signed_in?, :current_user

  def signed_in?
    !!session[:user_id]
  end

  def signed_in_with_github?
    current_user.provider == "github"
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  # def set_user
  #   @user = current_user
  # end

  def destroy_associated_plantings(object)
    object.plantings.each do |planting|
      planting.destroy
    end
  end

  def check_if_signed_in
    if !signed_in?
      flash[:message] = "Please sign in or create an account."
      redirect_to root_path
    end
  end

  def check_permission(object)
    if params[:user_id].to_i != current_user.id
      flash[:message] = "Sorry, the page you are looking for belongs to another user."
      redirect_to user_path(current_user.id)
    elsif !object
      flash[:message] = "Sorry, the page you are looking for does not appear to exist."
      redirect_to user_path(current_user.id)
    elsif object.user.id != current_user.id
     flash[:message] = "Sorry, the page you are looking for belongs to another user."
     redirect_to user_path(current_user.id)
    end
  end

end
