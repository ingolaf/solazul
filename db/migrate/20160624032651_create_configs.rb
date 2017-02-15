class CreateConfigs < ActiveRecord::Migration
  def change
    create_table :configs do |t|
      t.string :configuration_name
      t.string :configuration_value
      t.boolean :active

      t.timestamps null: false
    end
  end
end
