class AddHandledAttributeToFlags < ActiveRecord::Migration
  def self.up
    add_column :flags, :handled, :boolean, :default => false
  end

  def self.down
    remove_column :flags, :handled
  end
end
