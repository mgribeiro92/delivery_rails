class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :amount, presence: true
  validate :store_product, :amount_empty
  # after_destroy :update_order_total
  # after_save :update_order_total
  before_save :price_empty

  private

  # def update_order_total
  #   puts("ta passando no update order total")
  #   order.calculate_total
  #   order.save
  # end

  # def calculate_price
  #   puts('passando no calculate price')
  #   self.price = product.price * amount if product.price && amount
  #   puts(self.price)
  # end

  def amount_empty
    if self.amount == 0 || self.amount == nil
      errors.add(
        :order_item,
        "amount should exist"
      )
    end
  end

  def price_empty
    if self.price == nil
      errors.add(
        :order_item,
        "price should not be nil"
      )
    end
  end

  def store_product
    if product && order && product.store.name != order.store.name
      errors.add(
        :order,
        "should belong to 'Store': #{order.store.name}"
      )
    end
  end
end
