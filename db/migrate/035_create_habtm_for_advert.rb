class CreateHabtmForAdvert < ActiveRecord::Migration
  def self.up
    create_table :adverts_rich_attributes do |t|
      t.column :advert_id, :integer, :null => false
      t.column :rich_attribute_id, :integer, :null => false
    end
  end

  def self.down
    drop_table :adverts_rich_attributes
  end
end
