class AddFrequencyToAdvert < ActiveRecord::Migration
  def self.up
    add_column :adverts, :rent_frequency, :string
    add_column :adverts, :bills_frequency, :string
  end

  def self.down
    remove_column :adverts, :rent_frequency, :string
    remove_column :adverts, :bills_frequency, :string
  end
end
