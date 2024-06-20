require 'rails_helper'

RSpec.describe Message, type: :model do
  describe "validations" do
    it { should belong_to(:sender) }
    it { should belong_to(:chat_room) }
  end
end
