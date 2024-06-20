class AddInvetoryAndDescriptionToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :inventory, :integer
    add_column :products, :description, :text
  end
end
