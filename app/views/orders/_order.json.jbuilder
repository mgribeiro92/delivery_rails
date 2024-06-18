json.extract! order, :id, :created_at, :buyer_id, :store_id, :updated_at, :state, :total

json.user_email order.buyer.email
json.store_name order.store.name

json.order_items order.order_items do |order_item|
  json.id order_item.id
  json.product order_item.product
  json.amount order_item.amount
  json.price order_item.price
end

json.url order_url(order, format: :json)

# json.order_items order.order_items do |order_item|
#   json.partial! 'order_items/order_item', order_item: order_item
# end
