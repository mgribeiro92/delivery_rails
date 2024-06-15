class ChatRoomsController < ApplicationController
  skip_forgery_protection
  before_action :authenticate!
  before_action :set_chat_room, only: %i[ show ]

  def index
    if buyer?
      @chat_rooms = ChatRoom.where(buyer: current_user)
    end
  end

  def show
  end

  def last_chat
    if buyer?
      @chat_room = ChatRoom.where(buyer: current_user).last
      render :show
    end
  end

  def create
    @chat_room = ChatRoom.find_by(chat_room_params)

    unless @chat_room
      @chat_room = ChatRoom.new(chat_room_params)
      if @chat_room.save
        render json: @chat_room, status: :created
      else
        render json: @chat_room.errors, status: :unprocessable_entity
      end
    else
      render json: @chat_room, status: :ok
    end
  end

  private

  def chat_room_params
    params.require(:chat_room).permit(:buyer_id, :store_id)
  end

  def set_chat_room
    @chat_room = ChatRoom.find(params[:id])
  end
end
