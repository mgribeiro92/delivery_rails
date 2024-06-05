class Order < ApplicationRecord
  belongs_to :buyer, class_name: "User", required: true
  belongs_to :store, required: true
  has_many :order_items
  has_many :products, through: :order_items
  accepts_nested_attributes_for :order_items

  before_save :calculate_order_total
  validate :buyer_role, :store_product

  state_machine initial: :created do
    event :accept do
      transition created: :accepted
    end

    event :delivery do
      transition accepted: :delivery
    end

    event :finished do
      transition delivery: :finished
    end

    event :rejected do
      transition created: :rejected
    end
  end

  def calculate_order_total
    total = 0
    order_items.each do |item|
      product = Product.find(item.product_id)
      item.price = product.price * item.amount
      total += item.price
    end
    self.total = total
  end

  # def calculate_total
  #   puts("ta passando no calculate_total")
  #   self.total = order_items.sum(&:price)
  # end

  # def calculate_price
  #   puts('passando no calculate price')
  #   order_item.price = product.price * amount if product.price && amount
  #   puts(self.price)
  # end

  private

  def buyer_role
    if buyer && !buyer.buyer?
      errors.add(:buyer, "should be a 'user.buyer'")
    end
  end

  # def price_final
  #   price_order_items = order_items.sum(&:price)
  #   if price_order_items != self.total
  #     errors.add(
  #       :order,
  #       "value must be equal to the sum of order_items: #{price_order_items}"
  #     )
  #   end
  # end

  def store_product
    puts('passando no store_product')
    products.each do |product|
      if product.store.id != self.store.id
        errors.add(
          :order,
          "should belong to 'Store': #{self.store.name}, but product belongs to '#{product.store.name}'"
        )
      end
    end
  end

end
