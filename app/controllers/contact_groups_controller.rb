class ContactGroupsController < ApplicationController
  before_filter :signed_in_user

  def create
    current_user.add_contact_group!(params[:group_name])
    respond_to do |format|
      @msg = 'Create contats group success!'
      format.js { render :partial => 'new_cgroup_ok' }
    end
  end
  
  def destory
    current_user.rm_contact_group!(params[:group_name])
    respond_to do |format|
      @msg = 'Delete contactss group success!'
      format.js { render :partial => 'del_cgroup_ok' }
    end
  end
  
  def new
    @contact_group = ContactGroup.new
  end

  def show
    @group = current_user.contact_groups.find_by_group_name(params[:group_name])
  end
  
  def index
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
