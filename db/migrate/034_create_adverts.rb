class CreateAdverts < ActiveRecord::Migration
  #single table inheritance for flatseekers and flatshares
  def self.up
    create_table :adverts do |t|
      #common attributes
      t.column :user_id, :integer, :null => false
      t.column :created_on, :date
      t.column :type, :string, :null => false
      
      t.column :rent, :decimal, :precision => 8, :scale => 2, :null => false
      t.column :interests, :string
      t.column :description, :string, :null => false
      t.column :date_available, :date, :null => false
      t.column :area, :string, :null => false
      t.column :headline, :string, :null => false
      t.column :views_counter, :integer
      t.column :room_type, :string
      t.column :furnished, :boolean, :null => false
      t.column :smoking, :boolean, :null => false
      t.column :couples, :boolean
      
      #flatshare attributes
      t.column :bills, :decimal, :precision => 8, :scale => 2
      t.column :deposit, :decimal, :precision => 8, :scale => 2
      t.column :postcode, :string
      t.column :lat, :decimal, :precision => 15, :scale => 10
      t.column :lng, :decimal, :precision => 15, :scale => 10
      t.column :housemates, :integer
      
    end
  end

  def self.down
    drop_table :adverts
  end
end
