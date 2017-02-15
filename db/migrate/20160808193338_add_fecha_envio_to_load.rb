class AddFechaEnvioToLoad < ActiveRecord::Migration
  def change
  	add_column :loads, :sent_date, :datetime
  	add_column :loads, :order_number, :string
  	add_column :loads, :delivery_place, :string
  end
end
