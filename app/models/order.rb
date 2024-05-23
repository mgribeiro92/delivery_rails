class Order < ApplicationRecord
  belongs_to :buyer, class_name: "User", required: true
  belongs_to :store, required: true
  has_many :order_items
  has_many :products, through: :order_items

  validate :buyer_role

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
    puts(self.total)
  end

  private

  def buyer_role
    if buyer && !buyer.buyer?
      errors.add(:buyer, "should be a 'user.buyer'")
    end
  end


end
