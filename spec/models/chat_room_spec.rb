require 'rails_helper'

RSpec.describe ChatRoom, type: :model do
  describe "validations" do
    it { should belong_to(:buyer) }
    it { should belong_to(:store) }
  end
end
