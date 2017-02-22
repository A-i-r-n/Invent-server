class CreateBags < ActiveRecord::Migration
  def change
    create_table :bags do |t|
      t.string :name
      t.string :price
      t.string :color
      t.string :explain
    end
  end
end
