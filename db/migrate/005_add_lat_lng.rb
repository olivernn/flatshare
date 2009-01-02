class AddLatLng < ActiveRecord::Migration
  def self.up
    add_column :flatshares, :lat, :float, :null => false
    add_column :flatshares, :lng, :float, :null => false
  end

  def self.down
    remove_column :flatshares, :lat
    remove_column :flatshares, :lng
  end
end
