json.product do
  json.id @product.id
  json.title @product.id
  json.price @product.price
  if @product.image_product.attached?
    json.image_url rails_blob_url(@product.image_product, only_path: true)
  end
end
