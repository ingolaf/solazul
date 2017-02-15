class CreateLoads < ActiveRecord::Migration
  def change
    create_table :loads do |t|
      t.text :number
      t.float :percentage_completed

      t.timestamps null: false
    end
  end
end
