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

  def destroy
    session[:user_id] = nil
    redirect_to root_url
  end

  private

  # The following are needed to be able to add errors to @user under #create above

  attr_reader :errors

  def read_attribute_for_validation(attr)
    send(attr)
  end

  def self.human_attribute_name(attr, options = {})
    attr
  end

  def self.lookup_ancestors
    [self]
  end

end
