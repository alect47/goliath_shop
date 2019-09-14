require 'rails_helper'

describe "As an Admin User" do
  before :each do
    @admin_user = User.create!(  name: "chris",
      email: "8@gmail.com",
      password: "password",
      role: 3
    )
    @admin_user_address = @admin_user.addresses.create!(address: '123 Main st', city:'Denver', state:'CO', zip:80219)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin_user)
  end

  it "I see the same links as a regular user, a link to admin dashboard, and a link to show all users. I do not see a link to shopping cart." do
    visit '/'
    within 'nav' do
      expect(page).to have_link('All Merchants')
      expect(page).to have_link('All Items')
      expect(page).to have_link('Profile')
      expect(page).to have_link('Logout')
      expect(page).to have_link('Admin Dashboard')
      expect(page).to have_link('Users')
      expect(page).to_not have_link("Cart: 0")
    end
  end
end
