class ChatRoom < ApplicationRecord
  belongs_to :buyer, class_name: "User", required: true
  belongs_to :store
  has_many :messages
end
