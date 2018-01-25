class SessionsController < ApplicationController

  def new
    @user = User.new
  end

  def create

    @user = User.find_by(name: params[:user][:name])
    #@errors = ActiveModel::Errors.new(self)
    # binding.pry
    if @user && @user.authenticate(params[:user][:password])
      session[:user_id] = @user.id
      redirect_to user_path(@user) #, notice: "Welcome back to the theme park!"
    elsif !@user
      # @user = User.new
      flash[:message] = "Could not find your name."
      redirect_to signin_path # have to use redirect_to, rather than render, or else the flash message
        # appears when user successfully logs in
      # render 'sessions/new'
    elsif !@user.authenticate(params[:user][:password])
      # @user = User.new
      flash[:message] = "Password invalid."# or <%= link_to "create an account", new_user_path %>."
      redirect_to signin_path
      # render 'sessions/new'
    end
  end

  def create_from_github
    # raise "you hit create from github in sessions".inspect
    # @user = User.find_or_create_from_auth_hash(auth_hash)
    # # self.current_user = @user # GOING TO NEED TO FIGURE OUT HOW THIS INTERACTS WITH SESSION[:USER_ID]
    #   # probably will rest on the signed_in? helper...as well as the current_user helper
    # redirect_to '/'

   auth = request.env["omniauth.auth"]
   user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.create_user_from_github(auth)
   session[:user_id] = user.id
   flash[:message] = "Successfully signed in with GitHub"
   redirect_to user_path(user.id)
 end


  def destroy
    if signed_in_with_github?
      flash[:message] = "****You must sign out from github.com to completely sign out!!!****"
    end
    session.clear
    redirect_to root_path #'/'
  end

  private

  # From the omniauth page: (see create_from_github above)

  def auth_hash
    request.env['omniauth.auth']
  end


  # # The following are needed to be able to add errors to @user under #create above
  #
  # attr_reader :errors
  #
  # def read_attribute_for_validation(attr)
  #   send(attr)
  # end
  #
  # def self.human_attribute_name(attr, options = {})
  #   attr
  # end
  #
  # def self.lookup_ancestors
  #   [self]
  # end

end
