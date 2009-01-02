class IncreaseLengthOfDescription < ActiveRecord::Migration
  def self.up
    change_column :adverts, :description, :text, :null => false
  end

  def self.down
    change_column :adverts, :description, :string, :null => false
  end
end
