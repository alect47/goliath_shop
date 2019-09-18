require 'rails_helper'

describe Address, type: :model do
  describe "validations" do
    it { should validate_presence_of :nickname }
    it { should validate_presence_of :address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
  end

  describe "relationships" do
    it {should have_many :orders}
    it {should belong_to(:user)}
  end

  describe 'instance methods' do
    it 'grandtotal' do
      user = User.create!(  name: "alec",
        email: "5@gmail.com",
        password: "password"
      )
      user_address_1 = user.addresses.create!(address: '123 Main st', city:'Denver', state:'CO', zip:80219)
      order_1 = user.orders.create!(address_id: user_address_1.id)

      expect(user_address_1.no_shipped_orders?).to eq(true)
    end
  end
end
