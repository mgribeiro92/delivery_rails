class Store < ApplicationRecord
  belongs_to :user
  validates :name, presence: true, length: {minimum:3}
  has_many :products
end
