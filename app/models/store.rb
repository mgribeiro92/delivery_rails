class Store < ApplicationRecord
  belongs_to :user
  before_validation :ensure_seller
  validates :name, presence: true, length: {minimum:3}
  has_many :products
  has_many :orders
  has_many :chat_rooms
  has_one :address, as: :addressable
  has_one_attached :image
  # default_scope -> { where(soft_delete: false) }

  # geocoded_by :address
  # after_validation :geocode, if: ->(obj){ obj.address.present? and obj.address_changed? }

  def thumbnail
    image.variant(resize_to_limit: [100, 100]).processed
  end

  def high_quality_image
    image.variant(resize_to_limit: [800, 800]).processed
  end

  private

  def ensure_seller
    self.user = nil if self.user && !self.user.seller?
  end

end
