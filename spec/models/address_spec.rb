require 'rails_helper'

RSpec.describe Address, type: :model do
  describe "validations" do
    it { should belong_to(:addressable) }
  end

  let(:buyer) { create(:user_buyer) }
  let(:address) { create(:address, :for_user, addressable: buyer )}

  it "should geocode after validation if address attributes change" do
    address.save
    expect(address.latitude).to_not be_nil
    expect(address.longitude).to_not be_nil
  end

end
