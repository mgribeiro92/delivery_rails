require 'rails_helper'

RSpec.describe RefreshToken, type: :model do
  describe "validations" do
    it { should belong_to(:user) }
  end
end
