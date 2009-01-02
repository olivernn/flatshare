class CreateStations < ActiveRecord::Migration
  def self.up
    create_table :stations do |t|
      t.column :name, :string, :null => false
      t.column :postcode, :string, :null => false
      t.column :lat, :float, :null => false
      t.column :lng, :float, :null => false
    end
  end

  def self.down
    drop_table :stations
  end
end
