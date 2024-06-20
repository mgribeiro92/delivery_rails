class Product < ApplicationRecord
  belongs_to :store
  has_many :orders, through: :order_items
  has_one_attached :image_product

  validates :title, presence: true
  validates :inventory, numericality: { greater_than_or_equal_to: 0 }

  def thumbnail
    image_product.variant(resize_to_limit: [100, 100]).processed
  end

  def high_quality_image
    image_product.variant(resize_to_limit: [800, 800]).processed
  end

end
