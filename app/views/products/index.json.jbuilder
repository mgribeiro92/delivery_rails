json.result do
  if params[:page].present? and @products
    json.pagination do
      json.current @products.current_page
      json.per_page @products.limit_value
      json.pages @products.total_pages
      json.count @products.total_count
    end
  end

  json.products do
    json.array! @products do |product|
      json.extract! product, :id, :title, :price, :description, :inventory, :category
      json.image_url url_for(product.thumbnail) if product.image_product.attached?
    end
  end
end
