class CreateImages < ActiveRecord::Migration
  def self.up
    create_table :images do |t|
      t.column :advert_id, :integer
      t.column :parent_id, :integer
      t.column :filename, :string
      t.column :thumbnail, :string
      t.column :size, :integer
      t.column :width, :integer
      t.column :height, :integer
    end
  end

  def self.down
    drop_table :images
  end
end
