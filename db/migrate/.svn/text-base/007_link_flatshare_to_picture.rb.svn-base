class LinkFlatshareToPicture < ActiveRecord::Migration
  def self.up
    add_column :pictures, :flatshare_id, :integer, :null => false
  end

  def self.down
    remove_column :pictures, :flatshare_id
  end
end
