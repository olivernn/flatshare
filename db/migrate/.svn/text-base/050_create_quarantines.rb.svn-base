class CreateQuarantines < ActiveRecord::Migration
  def self.up
    create_table :quarantines do |t|
      t.column :advert_id, :integer, :null => false
      t.column :advert, :text, :null => false
      t.column :created_at, :timestamp, :null => false
    end
  end

  def self.down
    drop_table :quarantines
  end
end
