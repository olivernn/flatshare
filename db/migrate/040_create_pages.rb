class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.column :name, :string, :null => false
      t.column :permalink, :string
      t.column :content, :text, :null => false
    end
  end

  def self.down
    drop_table :pages
  end
end
