class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :amount, presence: true
  validate :store_product, :amount_empty
  before_save :price_empty
  after_save :calculate_order_item
  after_destroy :calculate_order_item

  def calculate_order_item
    order.calculate_order_total
    order.save
  end

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

  private

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
