json.extract! store, :id, :user_id, :name, :created_at, :updated_at, :description, :category, :address
if store.image.attached?
  json.image_url rails_blob_url(store.image, only_path: true)
end
json.url store_url(store, format: :json)

# if defined?(products) && products.any?
#   json.products products do |product|
#     json.id product.id
#     json.title product.title
#     json.price product.price
#     if product.image_product.attached?
#       json.image_url rails_blob_url(product.image_product, only_path: true)
#     end
#   end
# end
