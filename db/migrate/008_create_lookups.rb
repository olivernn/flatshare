class CreateLookups < ActiveRecord::Migration
  def self.up
    create_table :lookups do |t|
      t.column :area, :string, :null => false
      t.column :value, :string, :null => false
    end
  end

  def self.down
    drop_table :lookups
  end
end
