class CreateRules < ActiveRecord::Migration
  def change
    create_table :rules do |t|
      t.float :percentage_load
      t.integer :box_id
      t.float :max_discount
      t.boolean :active

      t.timestamps null: false
    end
  end
end
