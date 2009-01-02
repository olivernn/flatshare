class AddCrtstampToAdverts < ActiveRecord::Migration
  def self.up
    change_column :adverts, :created_on, :timestamp, :null => false
    rename_column :adverts, :created_on, :created_at
  end

  def self.down
    change_column :adverts, :created_on, :date, :null => false
    rename_column :adverts, :created_at, :created_on
  end
end
