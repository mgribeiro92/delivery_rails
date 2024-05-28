class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validate :store_product
  after_save :update_order_total
  after_destroy :update_order_total

  private

  def update_order_total
    order.calculate_total
    order.save
  end

  # def total_price
  #   amount * product.price
  # end

  def store_product
    if product && order && product.store.name != order.store.name
    puts(product.store.name)
    puts(order.store.name)
      errors.add(
        :order,
        "should belong to 'Store': #{order.store.name}"
      )
    end
  end
end
