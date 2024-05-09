require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:stores) }
  it { should have_one(:refresh_token) }


  
end
