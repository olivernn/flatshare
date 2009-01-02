class AddPlacesTable < ActiveRecord::Migration
  def self.up
    create_table :places do |t|
      t.column :user_id, :integer, :null => false
      t.column :created_on, :date
      t.column :name, :string, :null => false
      t.column :description, :string
      t.column :category, :string, :null => false
      t.column :postcode, :string, :null => false
      t.column :lat, :decimal, :precision => 15, :scale => 10
      t.column :lng, :decimal, :precision => 15, :scale => 10
    end
  end

  def self.down
    drop_table :places
  end
end
