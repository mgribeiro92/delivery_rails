require 'rails_helper'

RSpec.describe "/products", type: :request do

  let(:store) { create(:store)}

  let(:valid_attributes) {
    { title: "Pizza Marguerita", price: 40, store: store }
  }

  let(:invalid_attributes) {
    { title: nil}
  }
  
  describe

end
