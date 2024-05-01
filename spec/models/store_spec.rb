require 'rails_helper'

# RSpec.describe Store, type: :model do
#   describe "validations" do
#     it "should be valid when name is filled" do
#       store = Store.new name: "Greatest store ever!"
#       expect(store.valid?).to eq true
#     end
#   end
# end


# o metodo subject cria uma instacia da classe que esta sendo usada
# RSpec.describe Store, type: :model do
#   describe "validations" do
#     it "should validate presence of name" do

#       expect(subject).to_not be_valid
#     end
#   end
# end

# RSpec.describe Store, type: :model do
#   describe "validations" do
#     it "should validate presence of name" do
#       store = Store.new
#       expect(store).to_not be_valid
#     end
#   end
# end

RSpec.describe Store, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_length_of(:name).is_at_least(3) }
    it { should belong_to(:user) }
  end

  describe "belongs_to" do
    let(:seller) {
    user = User.new(
      email: "seller@example.com.br",
      password: "123456",
      password_confirmation: "123456",
      role: "seller"
    )
  }

    let(:admin) {
      user = User.new(
        email: "admin@example.com.br",
        password: "123456",
        password_confirmation: "123456",
        role: "admin"
      )
    }

    it "should not belong to admin user" do
      store = Store.create(name: "store", user: admin)

      expect(store.errors.full_messages).to eq ["User must exist"]
    end

  end
end
