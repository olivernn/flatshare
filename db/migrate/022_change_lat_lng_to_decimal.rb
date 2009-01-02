class ChangeLatLngToDecimal < ActiveRecord::Migration
  def self.up
    change_column :flatshares, :lat, :decimal, :precision => 15, :scale => 10
    change_column :flatshares, :lng, :decimal, :precision => 15, :scale => 10
    change_column :stations, :lat, :decimal, :precision => 15, :scale => 10
    change_column :stations, :lng, :decimal, :precision => 15, :scale => 10
  end

  def self.down
    change_column :flatshares, :lat, :float
    change_column :flatshares, :lng, :float
    change_column :stations, :lat, :float
    change_column :stations, :lng, :float
  end
end
