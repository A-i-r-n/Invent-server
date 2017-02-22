class CreateMusic < ActiveRecord::Migration
  def change
    create_table :musics do |t|
      t.string :name
      t.string :price
      t.string :explain
      t.datetime
    end
  end
end
