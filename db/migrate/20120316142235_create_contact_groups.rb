class CreateContactGroups < ActiveRecord::Migration
  def change
     create_table :contact_groups do |t|
      t.integer :owner_id
      t.string :group_name
      t.timestamps
    end
    add_index :contact_groups, :owner_id
    add_index :contact_groups, [:owner_id, :group_name], unique: true
  end
end
