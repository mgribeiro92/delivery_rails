json.extract! product, :id, :title, :price
if product.image.attached?
  json.image_url rails_blob_url(product.image, only_path: true)
end
json.url product_url(product, format: :json)

