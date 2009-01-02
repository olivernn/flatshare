class AddAreaIndex < ActiveRecord::Migration
  def self.up
    # add indexes to the areas table
    add_index :areas, :name
  end

  def self.down
    remove_index :areas, :name
  end
end
