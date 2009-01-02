class AddViewCounter < ActiveRecord::Migration
  def self.up
    add_column :flatshares, :views_counter, :integer
    add_column :flatseekers, :views_counter, :integer
  end

  def self.down
    remove_column :flatshares, :views_counter
    remove_column :flatseekers, :views_counter
  end
end
