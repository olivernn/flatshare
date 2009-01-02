class AddQuarantineFlagToAdverts < ActiveRecord::Migration
  def self.up
    add_column :adverts, :quarantine, :boolean, :default => false
  end

  def self.down
    remove_column :adverts, :quarantine
  end
end
