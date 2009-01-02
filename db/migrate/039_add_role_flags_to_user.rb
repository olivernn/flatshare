class AddRoleFlagsToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :authority, :integer, :default => 0
  end

  def self.down
    remove_column :users, :authority
  end
end
