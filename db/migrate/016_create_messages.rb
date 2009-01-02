class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.column :user_id, :integer, :null => false
      t.column :from, :string, :null => false
      t.column :message, :text, :null => false
      t.column :created_at, :timestamp, :null => false
      t.column :read, :boolean, :default => false, :null => false
    end
  end

  def self.down
    drop_table :messages
  end
end
