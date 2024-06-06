class AddCategoryAndDescriptionToStores < ActiveRecord::Migration[7.1]
  def change
    add_column :stores, :category, :string
    add_column :stores, :description, :text
  end
end
