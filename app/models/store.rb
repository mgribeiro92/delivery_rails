class Store < ApplicationRecord
  belongs_to :user
  before_validation :ensure_seller
  validates :name, presence: true, length: {minimum:3}
  has_many :products
  has_many :orders
  has_one :address, as: :addressable
  has_one_attached :image

  # geocoded_by :address
  # after_validation :geocode, if: ->(obj){ obj.address.present? and obj.address_changed? }

  private

  def ensure_seller
    self.user = nil if self.user && !self.user.seller?
  end

end
