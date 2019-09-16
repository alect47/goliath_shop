require 'rails_helper'

describe 'User Registration' do
  describe 'when user clicks on register' do
    it 'they can fill out a form to register new user' do

      visit '/'

      within 'nav' do
        click_link 'Register'
      end


      name = "alec"
      address = "234 Main"
      city = "Denver"
      state = "CO"
      zip = 80204
      email = "alec@gmail.com"
      password = "password"
      password_confirmation = "password"

      fill_in :name, with: name
      fill_in :address, with: address
      fill_in :city, with: city
      fill_in :state, with: state
      fill_in :zip, with: zip
      fill_in :email, with: email
      fill_in :password, with: password
      fill_in :password_confirmation, with: password_confirmation

      click_button("Submit")
      expect(current_path).to eq("/profile")
      within ".address-index" do
        expect(page).to have_content("Address: #{address} #{city} #{state} #{zip}")
        expect(page).to have_content("Nickname: Home")
      end

      address = Address.last
      expect(address.nickname).to eq("Home")
      expect(address.city).to eq(city)
    end
  end
end
