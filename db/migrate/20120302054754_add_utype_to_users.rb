class AddUtypeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :utype, :integer, default: 0

  end
end
