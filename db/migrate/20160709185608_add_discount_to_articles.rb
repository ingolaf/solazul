class AddDiscountToArticles < ActiveRecord::Migration
  def change
  	add_column :articles, :discount, :float
  end
end
