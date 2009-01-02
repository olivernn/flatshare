class ChangeCouplesIndName < ActiveRecord::Migration
  def self.up
    rename_column :flatshares, :availble_to_couples, :available_to_couples
  end

  def self.down
    rename_column :flatshares, :available_to_couples, :availble_to_couples
  end
end
