class CreateFlags < ActiveRecord::Migration
  def self.up
    create_table :flags do |t|
      t.column :user_id, :integer, :null => false
      t.column :advert_id, :integer, :null => false
      t.column :created_at, :timestamp, :null => false
      t.column :flag_type, :string, :null => false
      t.column :flag_comment, :text
    end
  end

  def self.down
    drop_table :flags
  end
end
