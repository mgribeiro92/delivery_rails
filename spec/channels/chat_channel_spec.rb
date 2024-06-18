require 'rails_helper'

RSpec.describe ChatChannel, type: :channel do
  let(:chat_room) { create(:chat_room) }

  it "subscribes to a stream with user and store" do
    subscribe(chat_room_id: chat_room.id)

    expect(subscription).to be_confirmed
    expect(subscription).to have_stream_for(chat_room)
  end

  it "rejects subscription when user is not authorized" do
    subscribe(chat_room_id: nil)  # Simular um usuário não autorizado
    expect(subscription).to be_rejected
  end
end
