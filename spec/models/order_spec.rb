require 'rails_helper'

describe Order, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
  end

  describe "relationships" do
    it {should have_many :item_orders}
    it {should have_many(:items).through(:item_orders)}
  end

  describe 'instance methods' do
    before :each do
      @user = User.create!(  name: "alec",
        address: "234 Main",
        city: "Denver",
        state: "CO",
        zip: 80204,
        email: "alec@gmail.com",
        password: "password"
      )
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)

      @order_1 = @user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)

      @order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
      @order_1.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 3)
    end

    it 'grandtotal' do
      expect(@order_1.grandtotal).to eq(230)
    end

    it 'total_quantity' do
      expect(@order_1.total_quantity).to eq(5)
    end

    it 'packaged' do
      @regular_user =  User.create!(  name: "alec",
                      address: "234 Main",
                      city: "Denver",
                      state: "CO",
                      zip: 80204,
                      email: "890@gmail.com",
                      password: "password"
                    )
      @order_1 = @regular_user.orders.create(name: "Sam Jackson", address: "234 Main St", city: "Seattle", state: "Washington", zip: 99987, status: 0)
      expect(@order_1.status).to eq("pending")
      @order_1.packaged
      expect(@order_1.status).to eq("packaged")
    end
  end
end
