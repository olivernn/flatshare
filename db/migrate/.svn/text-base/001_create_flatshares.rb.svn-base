class CreateFlatshares < ActiveRecord::Migration
  def self.up
    create_table :flatshares do |t|
      t.column :rent, :float, :null => false
      t.column :bills, :float
      t.column :postcode, :string, :null => false
      t.column :housemates, :integer, :null => false
      t.column :interests, :text
      t.column :description, :text, :null => false
      t.column :date_available, :date, :null => false
      t.column :advert_start_date, :date, :null => false
      t.column :availble_to_couples, :boolean, :null => false
    end
  end

  def self.down
    drop_table :flatshares
  end
end
