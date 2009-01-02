class CreateFlatseekers < ActiveRecord::Migration
  def self.up
    create_table :flatseekers do |t|
      t.column :max_rent, :decimal, :precision => 8, :scale => 2
      t.column :age, :integer
      t.column :interests, :string
      t.column :date_available, :date, :null => false
      t.column :advert_start_date, :date, :null => false
      t.column :description, :string, :null => false
      t.column :looking_as_couple, :boolean
      t.column :desired_location, :string, :null => false
    end
  end

  def self.down
    drop_table :flatseekers
  end
end
