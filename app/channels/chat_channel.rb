class ChatChannel < ApplicationCable::Channel
  def subscribed
    chat_room = ChatRoom.find(params[:chat_room_id])
    stream_for chat_room
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    message_params = data['message']
    chat_room_id = message_params['chat_room_id']
    chat_room = ChatRoom.find(chat_room_id)
    message = chat_room.messages.create!(
      content: message_params['content'],
      sent_at: message_params['sent_at'],
      sender_id: message_params['sender_id'],
      sender_type: message_params['sender_type']
    )

    ChatChannel.broadcast_to(chat_room, message)

    if message.sender_type == 'User'
      store_id = chat_room.store_id
      ActionCable.server.broadcast "notification_store_#{store_id}", { notification: "Você tem uma nova mensagem de #{chat_room.buyer.email}!" }
    else
      buyer_id = chat_room.buyer_id
      # NotificationChannel.broadcast_to("notification_user_#{buyer_id}", {
      #   notification: "Voce tem uma nova mensagem!"
      # })
      ActionCable.server.broadcast "notification_user_#{buyer_id}", { notification: "Você tem uma nova mensagem de #{chat_room.store.name}!" }
    end
  end
end
