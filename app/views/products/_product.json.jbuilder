json.extract! product, :id, :title, :price
if product.image_product.attached?
  json.image_url rails_blob_url(product.image_product, only_path: true)
end
json.url product_url(product, format: :json)
