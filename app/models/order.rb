class Order < ApplicationRecord
  belongs_to :buyer, class_name: "User", required: true
  belongs_to :store, required: true
  has_many :order_items
  has_many :products, through: :order_items

  validate :buyer_role, :price_final
  validate :store_product, on: :update

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

  def calculate_total
    self.total = order_items.sum(&:price)
  end

  private

  def buyer_role
    if buyer && !buyer.buyer?
      errors.add(:buyer, "should be a 'user.buyer'")
    end
  end

  def store_product
    if products.any? { |product| product.store.id != self.store.id }
      errors.add(
        :order,
        "should belong to 'Store': #{products.first.store.name}"
      )
    end
  end

  def price_final
    price_order_items = self.order_items.sum(&:price)
    if price_order_items != self.total
      errors.add(
        :order,
        "value must be equal to the sum of order_items: #{price_order_items}"
      )
    end
  end


end
