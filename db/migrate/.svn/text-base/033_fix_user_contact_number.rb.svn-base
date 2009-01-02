class FixUserContactNumber < ActiveRecord::Migration
  def self.up
    change_column :users, :contact_number, :integer, :limit => 15
  end

  def self.down
    change_column :users, :contact_number, :integer, :limit => 4
  end
end
