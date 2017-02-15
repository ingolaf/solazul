class AddDozensBoxesSizesToInventories < ActiveRecord::Migration
  def change
  	add_column :inventories, :price_id, :integer
  	add_column :inventories, :total_boxes, :integer
  	add_column :inventories, :package, :string
  	add_column :articles, :price_id, :integer
  	add_column :articles, :total_boxes, :integer
  	add_column :articles, :package, :string
  	add_column :articles, :description, :string
  	add_column :transactions, :price_id, :integer
  	add_column :transactions, :total_boxes, :integer
  	add_column :transactions, :package, :string
  end
end
