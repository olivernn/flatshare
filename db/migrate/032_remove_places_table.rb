class RemovePlacesTable < ActiveRecord::Migration
  def self.up
    drop_table :places
  end

  def self.down
    create_table :places do |t|
      t.column :user_id, :integer, :null => false
      t.column :name, :string, :null => false
      t.column :description, :string, :null => false
      t.column :place_type, :string, :null => false
      t.column :postcode, :string, :null => false
      t.column :lat, :decimal, :precision => 15, :scale => 10
      t.column :lng, :decimal, :precision => 15, :scale => 10
      t.column :created_at, :timestamp, :null => false
    end
  end
end
