class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :load_id
      t.string :number
      t.string :customer_name
      t.datetime :date
      t.float :percentage_complete
      t.float :total
      t.float :subtotal
      t.float :taxes
      t.integer :status
      t.integer :order_type
      t.boolean :active

      t.timestamps null: false
    end
  end
end
