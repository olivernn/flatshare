class AddIndexes < ActiveRecord::Migration
  def self.up
    #adverts table index
    add_index :adverts, :user_id
    add_index :adverts, :area
    add_index :adverts, :rent
    add_index :adverts, :type
    
    #users table index
    add_index :users, :email
    
    #stations table index
    add_index :stations, :name
    
    #pictures table index
    add_index :pictures, :advert_id
    
    #lookups table index
    add_index :lookups, :name
    
    #help_texts table index
    add_index :help_texts, :name
    
    #messages table index
    add_index :messages, :user_id
    add_index :messages, :created_at
  end

  def self.down
    #adverts table index
    remove_index :adverts, :user_id
    remove_index :adverts, :area
    remove_index :adverts, :rent
    remove_index :adverts, :type
    
    #users table index
    remove_index :users, :email
    
    #stations table index
    remove_index :stations, :name
    
    #pictures table index
    remove_index :pictures, :advert_id
    
    #lookups table index
    remove_index :lookups, :name
    
    #help_texts table index
    remove_index :help_texts, :name
    
    #messages table index
    remove_index :messages, :user_id
    remove_index :messages, :created_at
  end
end
