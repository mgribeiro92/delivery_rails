json.stores do
  json.array! @stores do |store|
    json.extract! store, :id, :name, :created_at, :updated_at, :description, :category
    
    if store.address.present?
      json.distance store.address.distance_to(user_coordinates).round(2)
    else
      json.distance nil
    end
    if store.image.attached?
      json.image_url rails_blob_url(store.image, only_path: true)
    end
  end
end
