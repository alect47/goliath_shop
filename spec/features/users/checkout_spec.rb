require 'rails_helper'

describe "when regular user visits cart" do
  before :each do
    @meg = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @regular_user = User.create!(  name: "alec",
      email: "5@gmail.com",
      password: "password"
    )
    @regular_user_address = @regular_user.addresses.create!(address: '123 Main st', city:'Denver', state:'CO', zip:80219)

    @merchant_employee_user = @meg.users.create!(  name: "alec",
                        email: "6@gmail.com",
                        password: "password",
                        role: 1)
    @merchant_employee_user_address = @merchant_employee_user.addresses.create!(address: '123 Main st', city:'Denver', state:'CO', zip:80219)

    @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @tire = @meg.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @paper = @mike.items.create!(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
    @pencil = @mike.items.create!(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
    visit "/items/#{@tire.id}"
    click_on "Add To Cart"
    visit '/login'
    fill_in :email, with: @regular_user.email
    fill_in :password, with: @regular_user.password
    click_button "Log In"
  end
  it "they can checkout and and order is created associated with user" do

    visit cart_path

    choose("order_address_id_#{@regular_user_address.id}")
    click_button "Create Order"

    expect(current_path).to eq("/profile/orders")
    order = Order.last
    expect(order.status).to eq("pending")
    expect(order.user_id).to eq(@regular_user.id)
    expect(page).to have_content("Order Created!")

    visit '/cart'
    expect(page).to have_content("Cart is currently empty")
    expect(page).to_not have_link("Checkout")

    click_link "Logout"
    visit '/login'

    fill_in :email, with: @merchant_employee_user.email
    fill_in :password, with: @merchant_employee_user.password

    click_button "Log In"

    visit '/merchant'
    click_link "#{order.id}"
    expect(current_path).to eq("/merchant/orders/#{order.id}")

    within "#item-#{@tire.id}" do
      expect(page).to have_link("Fulfill #{@tire.name}")
      click_link("Fulfill #{@tire.name}")
    end

    expect(current_path).to eq("/merchant/orders/#{order.id}")
    expect(page).to have_content("#{@tire.name} is now fulfilled")
    within "#item-#{@tire.id}" do
      expect(page).to_not have_link("Fulfill #{@tire.name}")
      expect(page).to have_content("#{@tire.name} is fulfilled")
    end
    visit "/items/#{@tire.id}"
    expect(page).to have_content("Inventory: 11")
  end
end
