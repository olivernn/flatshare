class AddUserId < ActiveRecord::Migration
  def self.up
    add_column :flatshares, :user_id, :integer, :null => false
    add_column :flatseekers, :user_id, :integer, :null => false
  end

  def self.down
    remove_column :flatshares, :user_id
    remove_column :flatseekers, :user_id
  end
end
