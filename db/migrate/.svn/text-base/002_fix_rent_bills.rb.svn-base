class FixRentBills < ActiveRecord::Migration
  def self.up
    change_column :flatshares, :rent, :decimal, :precision => 8, :scale => 2
    change_column :flatshares, :bills, :decimal, :precision => 8, :scale => 2
  end

  def self.down
    change_column :flatshares, :rent, :float
    change_column :flatshares, :bills, :float
  end
end
