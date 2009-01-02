class CreatePromotions < ActiveRecord::Migration
  def self.up
    create_table :promotions do |t|
      t.column :code, :string, :null => false
      t.column :number_of_uses, :integer
      t.column :start_date, :date, :null => false
      t.column :end_date, :date, :null => false
    end
  end

  def self.down
    drop_table :promotions
  end
end
