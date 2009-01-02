class FixJoinTable < ActiveRecord::Migration
  def self.up
    rename_column :flatshares_rich_attributes, :flatshares_id, :flatshare_id
  end

  def self.down
    rename_column :flatshares_rich_attributes, :flatshare_id, :flatshares_id
  end
end
