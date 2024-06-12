json.product do
  json.id @product.id
  json.title @product.title
  json.price @product.price
  json.store_id @product.store.id
  json.description @product.description
  json.store_name @product.store.name
  # if @product.image_product.attached?
  #   json.image_url rails_blob_url(@product.image_product, only_path: true)
  # end
  json.image_url url_for(@product.high_quality_image) if @product.image_product.attached?
end
