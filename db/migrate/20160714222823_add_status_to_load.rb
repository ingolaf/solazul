class AddStatusToLoad < ActiveRecord::Migration
  def change
    add_column :loads, :status, :string
  end
end
