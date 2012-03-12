class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.integer :owner_id
      t.integer :contact_id
      t.string :contact_group
      t.string :contact_alias

      t.timestamps
    end
    add_index :contacts, :owner_id
    add_index :contacts, :contact_id
    add_index :contacts, [:owner_id, :contact_id], unique: true
  end
  
end
