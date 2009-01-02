class AddFrequencyToFlatshare < ActiveRecord::Migration
  def self.up
    add_column :flatshares, :rent_frequency, :string, :null => false
    add_column :flatshares, :bills_frequency, :string, :null => false
  end

  def self.down
    remove_column :flatshares, :rent_frequency
    remove_column :flatshares, :bills_frequency
  end
end
