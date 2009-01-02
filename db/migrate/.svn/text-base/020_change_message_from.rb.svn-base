class ChangeMessageFrom < ActiveRecord::Migration
  def self.up
     remove_column :messages, :from
     add_column :messages, :from_id, :integer, :null => false
  end

  def self.down
    remove_column :messages, :from_id
    add_column :messages, :from, :string, :null => false
  end
end
