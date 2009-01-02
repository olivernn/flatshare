class AddPromotionDescription < ActiveRecord::Migration
  def self.up
    add_column :promotions, :name, :string, :null => false
  end

  def self.down
    remove_column :promotion, :name
  end
end
