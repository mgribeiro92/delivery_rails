class Order < ApplicationRecord
  belongs_to :buyer, class_name: "User", required: true
  belongs_to :store, required: true
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items
  accepts_nested_attributes_for :order_items

  before_save :calculate_order_total
  validate :buyer_role, :store_product
  before_create :check_product_inventory
  after_create :reduce_product_inventory

  state_machine initial: :created do
    event :payment_failure do
      transition created: :payment_failure
    end

    event :payment_success do
      transition created: :payment_success
    end

    event :accept do
      transition payment_success: :accepted
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

  private

  def buyer_role
    if buyer && !buyer.buyer?
      errors.add(:buyer, "should be a 'user.buyer'")
    end
  end

  def check_product_inventory
    order_items.each do |item|
      product = item.product
      if product.inventory < item.amount
        errors.add(:error, "O produto #{product.title} não tem estoque suficiente. O estoque é de #{product.inventory}.")
      end
    end
  end


  def reduce_product_inventory
    order_items.each do |item|
      product = item.product
      product.inventory -= item.amount
      product.save!
    end
  end

  def store_product
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
