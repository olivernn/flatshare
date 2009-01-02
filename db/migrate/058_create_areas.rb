class CreateAreas < ActiveRecord::Migration
  def self.up
    create_table :areas do |t|
      t.column :name, :string, :null => false
      t.column :borough, :string, :null => false
      t.column :postcode_area, :string, :null => false
      t.column :description, :text
    end
  end

  def self.down
    drop_table :areas
  end
end
