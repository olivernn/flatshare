class RemoveRichAttributeHabtmIndex < ActiveRecord::Migration
  def self.up
    remove_column :adverts_rich_attributes, :id
  end

  def self.down
    add_column :adverts_rich_attributes, :id, :integer
  end
end
