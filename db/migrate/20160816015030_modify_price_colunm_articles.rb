class ModifyPriceColunmArticles < ActiveRecord::Migration
  def change
  	rename_column :articles, :price, :unit_price
  end
end
