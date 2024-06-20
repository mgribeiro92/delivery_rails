class AddDeletedToMultipleTables < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :soft_delete, :boolean, default: false, null: false
    add_column :products, :soft_delete, :boolean, default: false, null: false
    add_column :stores, :soft_delete, :boolean, default: false, null: false
  end
end
