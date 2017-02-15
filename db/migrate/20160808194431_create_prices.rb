class CreatePrices < ActiveRecord::Migration
  def change
    create_table :prices do |t|
      t.integer :box_id
      t.integer :box_size_small
      t.integer :box_size_big
      t.integer :dozens_by_size
      t.string :price_by_dozen
      t.string :weight_by_dozen

      t.timestamps null: false
    end
  end
end
