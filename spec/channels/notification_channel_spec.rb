require 'rails_helper'

RSpec.describe NotificationChannel, type: :channel do
  let(:store) { create(:store) }
  let(:user) { create(:user_buyer) }

  it "subscribes to user notifications" do
    subscribe(type: 'user', id: user.id)
    expect(subscription).to be_confirmed
    expect(subscription).to have_stream_from("notification_user_#{user.id}")
  end

  it "subscribes to store notifications" do
    subscribe(type: 'store', id: store.id)
    expect(subscription).to be_confirmed
    expect(subscription).to have_stream_from("notification_store_#{store.id}")
  end

  it "rejects subscription for unknown type" do
    subscribe(type: 'unknown', id: 1)
    expect(subscription).to be_rejected
  end
  
end
