class CreateManyToManyJoinTables < ActiveRecord::Migration
  def self.up
    create_table :flatseekers_rich_attributes do |t|
      t.column :flatseeker_id, :integer, :null => false
      t.column :rich_attribute_id, :integer, :null => false
    end
      
    create_table :flatshares_rich_attributes do |t|
      t.column :flatshares_id, :integer, :null => false
      t.column :rich_attribute_id, :integer, :null => false
    end
  end

  def self.down
    drop_table :flatseekers_rich_attributes
    drop_table :flatshares_rich_attributes
  end
end
