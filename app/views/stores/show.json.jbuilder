json.id @store.id
json.name @store.name
json.description @store.description
json.category @store.category
json.address @store.address
json.image_url url_for(@store.high_quality_image) if @store.image.attached?
