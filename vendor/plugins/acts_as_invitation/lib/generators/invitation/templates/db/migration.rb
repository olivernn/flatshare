class <%= migration_name %> < ActiveRecord::Migration
  def self.up
    create_table :<%= table_name %> do |t|
      t.column :title, :string
      t.column :comments, :text
      t.column :created_at, :datetime
      t.column :recipients, :string
      
      # Comment this if you don't want to track the user who sent the invitation.
      t.column :user_id, :integer

      # Comment these if you are only going to track invitations of one object (and thus don't need polymorphism)
      t.column :invited_id, :integer
      t.column :invited_type, :string
      
      # Uncomment (and edit) this line for non-polymorphic invitations (i.e. if users can only invite others
      #   to see one type of thing)
      #t.column :photo_id, :integer
    end
  end

  def self.down
    drop_table :<%= table_name %>
  end
end
