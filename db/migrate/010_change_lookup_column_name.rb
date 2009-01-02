class ChangeLookupColumnName < ActiveRecord::Migration
  def self.up
    rename_column :lookups, :area, :name
  end

  def self.down
    rename_column :lookups, :name, :area
  end
end
