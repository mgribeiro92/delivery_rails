class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validate :store_product

  private

  def store_product
    if product && order && product.store.id != order.store.id
      errors.add(
        :product,
        "should belong to 'Store': #{order.store.name}"
      )
    end
  end
end
