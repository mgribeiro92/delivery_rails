json.chats do
  json.array! @chat_rooms do |chat_room|
    json.id chat_room.id
    json.buyer_id chat_room.buyer_id
    json.buyer_email chat_room.buyer.email
    json.store_id chat_room.store_id
    json.store_name chat_room.store.name
  end
end
