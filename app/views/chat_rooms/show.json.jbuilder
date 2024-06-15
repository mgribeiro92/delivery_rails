json.chat do
  json.id @chat_room.id
  json.buyer_id @chat_room.buyer_id
  json.buyer_email @chat_room.buyer.email
  json.store_id @chat_room.store_id
  json.store_name @chat_room.store.name
end

json.chat_messages @chat_room.messages do |message|
  json.id message.id
  json.content message.content
  json.sent_at message.sent_at
  json.sender_type message.sender_type
  json.sender_id message.sender_id
end
