class ContactGroupsController < ApplicationController
  before_filter :signed_in_user

  def create
    current_user.add_contact_group!(params[:contact_group])
    respond_to do |format|
      @msg = 'Create contats group success!'
      format.js { render :partial => 'new_cgroup_ok' }
    end
  end
  
  def destroy
    current_user.rm_contact_group!(params[:id])
    respond_to do |format|
      @msg = 'Delete contactss group success!'
      format.js { render :partial => 'del_cgroup_ok' }
    end
  end
  
  def new
    @contact_group = ContactGroup.new
  end

  def edit
    @contact_group = current_user.contact_groups.find(params[:id])
  end

  def show
    @group = current_user.contact_groups.find_by_group_name(params[:group_name])
  end
  
  def index
    @contact_groups = current_user.contact_groups.paginate(page: params[:page], per_page: 10)
    respond_to do |format|
      format.js
      format.html { render :partial => 'index' }
    end
  end
  
  def update
    @contact_group = current_user.contact_groups.find(params[:id])
    respond_to do |format|
      if @contact_group.update_attributes(params[:contact_group])
        format.js { render :partial => 'update_ok' }
      else
        @msg = 'Update contact group failed!'
        format.js { render :partial => 'shared/alert' }
      end
    end
  end

  def list
    @groups = {}
    # default group
    @groups['Default'] = current_user.contacts.find_all_by_contact_group(-1)
    grps = current_user.contact_groups
    for grp in grps
      @groups[grp.group_name] = current_user.contacts.find_all_by_contact_group(grp.id)
    end
    render :partial => 'contacts'
  end
end
