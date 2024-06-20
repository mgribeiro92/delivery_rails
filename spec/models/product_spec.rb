require 'rails_helper'

RSpec.describe Product, type: :model do
  describe "validations" do
    it { should belong_to(:store) }
  end
end
