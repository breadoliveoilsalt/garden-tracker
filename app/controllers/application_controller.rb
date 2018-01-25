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
    #Think about why I am doing it this way:
    # the ||= framework is to keep you from having to fire up the database everytime current_user is called, ie,
    # @current_user just stays in memory after the first time it is called and database fired
    @current_user ||= User.find_by(id: session[:user_id])
  end



  # Think about if I need something like this
  # def require_logged_in
  #   return redirect_to(controller: 'sessions', action: 'new') unless logged_in?
  # end
end
