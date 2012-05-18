class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:index, :edit, :update]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :admin_user,     only: :destroy
  
  include UsersHelper
  
  def index
    @users = User.paginate(page: params[:page], per_page: 7)
    respond_to do |format|
      format.js render :partial => 'index'
    end
  end
  
  def new
    @title = 'Sign up'
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Zim!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_path
  end
  
  def contacts
    @title = "Contacts"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_contact'
  end

  private

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end
end
