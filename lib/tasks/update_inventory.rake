namespace :db do
  desc "Atualiza o estoque dos produtos existentes para 0 se for nil"
  task update_inventory: :environment do
    Product.where(inventory: nil).update_all(inventory: 0)
  end
end
