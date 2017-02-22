class CreateCosmetic < ActiveRecord::Migration
  def change
    create_table :cosmetics do |t|
      t.string :name
      t.string :price
      t.string :explain
    end
  end
end
