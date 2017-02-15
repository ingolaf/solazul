class CreateInventories < ActiveRecord::Migration
  def change
    create_table :inventories do |t|
      t.integer :box_id
      t.datetime :update_date
      t.integer :quantity

      t.timestamps null: false
    end
  end
end
