class AssociatePicturesWithAdverts < ActiveRecord::Migration
  def self.up
    rename_column :pictures, :flatshare_id, :advert_id
  end

  def self.down
    rename_column :pictures, :advert_id, :flatshare_id
  end
end
