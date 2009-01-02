class FixContactNumber < ActiveRecord::Migration
  def self.up
    change_column :users, :contact_number, :string, :null => false
  end

  def self.down
    change_column :users, :contact_number, :int
  end
end
