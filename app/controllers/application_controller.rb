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

end
