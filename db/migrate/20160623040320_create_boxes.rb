class CreateBoxes < ActiveRecord::Migration
  def change
    create_table :boxes do |t|
      t.string :description
      t.float :price
      t.integer :capacity
      t.float :minimum_percentage_load
      t.boolean :active

      t.timestamps null: false
    end
  end
end
