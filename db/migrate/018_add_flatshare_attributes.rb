class AddFlatshareAttributes < ActiveRecord::Migration
  def self.up
    add_column :flatshares, :room_type, :string, :null => false
    add_column :flatshares, :furnished, :boolean, :null => false
    add_column :flatshares, :deposit, :decimal, :precision => 8, :scale => 2
    add_column :flatshares, :smoking, :boolean, :null => false
    add_column :flatshares, :headline, :string, :null => false
  end

  def self.down
    remove_column :flatshares, :room_type
    remove_column :flatshares, :furnished
    remove_column :flatshares, :deposit
    remove_column :flatshares, :smoking
    remove_column :flatshares, :headline
  end
end
