class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:index, :edit, :update]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :admin_user,     only: :destroy
  
  include UsersHelper
  require 'will_paginate/array'
  
  def index
    qemail = params[:qemail] ? '%'+params[:qemail]+'%' : '%'
    qname = params[:qname] ? '%'+params[:qname]+'%' : '%'
    @users = User.where('email like ? AND name like ?', qemail, qname).paginate(page: params[:page], per_page: 10)
    respond_to do |format|
      format.js
      format.html { render :partial => 'index' }
    end
  end
  
  def new
    @title = 'Sign up'
    @user = User.new
    respond_to do |format|
      format.js { render :partial => 'new' }
    end
  end

  def show
    @user = User.find(params[:id])
    respond_to do |format|
      format.js { render :partial => 'show' }
    end
  end

  def create
    @user = User.new(params[:user])
    respond_to do |format|
      if @user.save
        sign_in @user
        format.js { render :partial => 'signup_ok' }
      else
        @error_msg = 'Sign up failed!';
        format.js { render :partial => 'alert' }
      end
    end
  end

  def edit
    @user = User.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  def update
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:success] = "Profile updated"
        sign_in @user
        format.js { render :partial => 'update_ok' }
      else
        @error_msg = 'Settings update failed!'
        format.js { render :partial => 'alert' }
      end
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
