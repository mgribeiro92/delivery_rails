class MessagesController < ApplicationController
  skip_forgery_protection

  def create
    # @chat_room = ChatRoom.find(params[:chat_room_id])
    @message = Message.new(message_params)
    # ChatChannel.broadcast_to(@chat_room, @message)
    if @message.save
      render json: @message
    else
      render json: @message.errors
    end
  end

  private

  def message_params
    params.require(:message).permit(:content, :sent_at, :sender_id, :sender_type, :chat_room_id)
  end
end
