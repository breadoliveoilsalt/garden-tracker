class SessionsController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.find_by(name: params[:user][:name])
    if @user && @user.authenticate(params[:user][:password])
      session[:user_id] = @user.id
      redirect_to user_path(@user)
    elsif !@user
      flash[:message] = "Error: Could not find your name."
      redirect_to signin_path
    elsif !@user.authenticate(params[:user][:password])
      flash[:message] = "Error: Password invalid."
      redirect_to signin_path
    end
  end

  def create_from_github
   auth = request.env["omniauth.auth"]
   user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.create_user_from_github(auth)
   session[:user_id] = user.id
   flash[:message] = "Successfully signed in with GitHub"
   redirect_to user_path(user.id)
 end

  def destroy
    if signed_in_with_github?
      flash[:message] = "****You must go to github.com and sign out there to completely sign out here!!!****"
    end
    session.clear
    redirect_to root_path
  end

end
