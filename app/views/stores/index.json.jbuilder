json.stores do
  json.array! @stores do |store|
    json.extract! store, :id, :name, :created_at, :updated_at, :description, :category

    if store.address.present? && store.address.latitude? && defined?(user_coordinates)
      json.distance store.address.distance_to(user_coordinates).round(2)
    else
      json.distance nil
    end
    json.image_url url_for(store.thumbnail) if store.image.attached?
  end
end
