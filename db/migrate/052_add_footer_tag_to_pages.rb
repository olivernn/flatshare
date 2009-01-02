class AddFooterTagToPages < ActiveRecord::Migration
  def self.up
    add_column :pages, :footer_page, :boolean, :default => false
  end

  def self.down
    remove_column :pages, :footer_page
  end
end
