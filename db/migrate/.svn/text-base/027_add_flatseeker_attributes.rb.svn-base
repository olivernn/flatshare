class AddFlatseekerAttributes < ActiveRecord::Migration
  def self.up
    add_column :flatseekers, :room_type, :string, :null => false
    add_column :flatseekers, :headline, :string, :null => false
    add_column :flatseekers, :furnished, :boolean, :null => false
  end

  def self.down
    remove_column :flatseekers, :room_type
    remove_column :flatseekers, :headline
    remove_column :flatseekers, :furnished
  end
end
