class AddIndexToContactGroupsGroupNameAndOwnerId < ActiveRecord::Migration
  def change
    def change
    add_index :contact_groups, [:owner_id, :group_name], unique: true
  end
  end
end
