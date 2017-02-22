class CreateShoes < ActiveRecord::Migration
  def change
    create_table :shoes do |t|
      t.string :name
      t.string :price
      t.string :color
      t.string :height
    end
  end
end
