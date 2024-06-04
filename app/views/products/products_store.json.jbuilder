json.result do
  if params[:page].present?
    json.pagination do
      json.current @products.current_page
      json.per_page @products.limit_value
      json.pages @products.total_pages
      json.count @products.total_count
    end
  end

  json.products do
    json.array! @products do |product|
      json.extract! product, :id, :title, :price
      if product.image_product.attached?
        json.image_url rails_blob_url(product.image_product, only_path: true)
      end
    end
  end
end

