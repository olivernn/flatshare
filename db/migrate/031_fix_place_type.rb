class FixPlaceType < ActiveRecord::Migration
  def self.up
    rename_column :places, :type, :place_type
  end

  def self.down
    rename_column :places, :place_type, :type
  end
end
