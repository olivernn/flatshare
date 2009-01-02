class AddFreqToFlatseeker < ActiveRecord::Migration
    def self.up
      add_column :flatseekers, :rent_frequency, :string, :null => false
    end

    def self.down
      remove_column :flatshares, :rent_frequency
    end
end