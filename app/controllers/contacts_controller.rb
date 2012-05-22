class ContactsController < ApplicationController
  before_filter :signed_in_user

  require 'will_paginate/array'

  def create
    @id = params[:contact][:id]
    @user = User.find(@id)
    c_alias = params[:contact][:contact_alias] == '' ? nil : params[:contact][:contact_alias]
    current_user.add_contact! @user, params[:group][:id], c_alias
    respond_to do |format|
      @msg = 'Add contact success!'
      format.js { render :partial => 'alert' }
    end
  end

  def edit
    @contact = current_user.contacts.find(params[:id])
    @groups = current_user.contact_groups
    respond_to do |format|
      format.js 
    end
  end

  def destroy
    current_user.rm_contact! Contact.find(params[:id]).contact 
    respond_to do |format|
      @msg = 'Delete success!'
      format.js { render :partial => 'alert' }
    end
  end
  
  def new
    @id = params[:id]
    @groups = current_user.contact_groups
    @contact = Contact.new
  end

  def update
    @contact = current_user.contacts.find(params[:id])
    respond_to do |format|
      if @contact.update_attributes(params[:contact])
        format.js { render :partial => 'update_ok' }
      else
        @msg = 'Update contact failed!'
        format.js { render :partial => 'shared/alert' }
      end
    end

  end

  def show
  end
  
  def index
    qemail = params[:qemail] ? '%'+params[:qemail]+'%' : '%'
    qname = params[:qname] ? '%'+params[:qname]+'%' : '%'
    @contacts = current_user.contact_users
      .where('email like ? AND name like ?', qemail, qname).paginate(page: params[:page], per_page: 10)
    #@contacts = current_user.contacts.paginate(page: params[:page], per_page: 10)
    respond_to do |format|
      format.js
      format.html { render :partial => 'index' }
    end
  end

end
