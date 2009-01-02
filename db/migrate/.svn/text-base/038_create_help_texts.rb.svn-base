class CreateHelpTexts < ActiveRecord::Migration
  def self.up
    create_table :help_texts do |t|
      t.column :name, :string, :null => false
      t.column :help_text, :string, :null => false
    end
  end

  def self.down
    drop_table :help_texts
  end
end
