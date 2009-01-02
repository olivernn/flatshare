class AddAreaToFlatshare < ActiveRecord::Migration
  def self.up
    add_column :flatshares, :area, :string, :null => false
  end

  def self.down
    remove_column :flatshares, :area
  end
end
