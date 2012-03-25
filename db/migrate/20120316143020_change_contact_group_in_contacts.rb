class ChangeContactGroupInContacts < ActiveRecord::Migration
  def up
    change_column(:contacts, :contact_group, :integer, :default => -1)
  end

  def down
    change_column(:contacts, :contact_group, :string)
  end
end
