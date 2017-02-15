class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.integer :quantity
      t.integer :article_id
      t.datetime :date
      t.integer :article_id
      t.boolean :active

      t.timestamps null: false
    end
  end
end
