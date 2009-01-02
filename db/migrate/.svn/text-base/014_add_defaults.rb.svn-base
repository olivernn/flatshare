class AddDefaults < ActiveRecord::Migration
  def self.up
    remove_column :flatshares, :advert_start_date
    remove_column :flatseekers, :advert_start_date
    
    add_column :flatshares, :created_on, :date
    add_column :flatseekers, :created_on, :date
  end

  def self.down
    add_column :flatshares, :advert_start_date, :date
    add_column :flatseekers, :advert_start_date, :date
    
    remove_column :flatshares, :created_on, :date
    remove_column :flatseekers, :created_on, :date
  end
end
