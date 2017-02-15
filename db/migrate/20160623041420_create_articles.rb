class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.integer :quantity
      t.integer :box_id
      t.float :price
      t.float :total
      t.integer :order_id

      t.timestamps null: false
    end
  end
end
