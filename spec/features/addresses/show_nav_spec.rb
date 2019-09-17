require 'rails_helper'

describe "User Profile Addresses" do
  describe "As a registered user" do
    before :each do
      @user = User.create!(  name: "alec",
        email: "5@gmail.com",
        password: "password"
      )
      @user_address = @user.addresses.create!(address: '123 Main st', city:'Denver', state:'CO', zip:80219)
      @user_address_2 = @user.addresses.create!(address: '423 Main st', city:'Denver', state:'CO', zip:80219)

      visit '/login'

      fill_in :email, with: @user.email
      fill_in :password, with: @user.password

      click_button "Log In"
    end
    it 'when user visits profile they see links to edit, delete and add addresses' do
      visit '/profile'

      within "#address-#{@user_address.id}" do
        expect(page).to have_link("Edit")
        expect(page).to have_link("Delete")
      end

      within "#address-#{@user_address_2.id}" do
        expect(page).to have_link("Edit")
        expect(page).to have_link("Delete")
      end

      within ".address-index" do
        expect(page).to have_link("New Address")
      end
    end
    it 'when user clicks edit they can edit address' do
      visit '/profile'

      within "#address-#{@user_address.id}" do
        click_link "Edit"
      end
      expect(current_path).to eq("/profile/addresses/#{@user_address.id}/edit")
      expect(find_field(:nickname).value).to eq(@user_address.nickname)
      expect(find_field(:address).value).to eq(@user_address.address)
      expect(find_field(:city).value).to eq(@user_address.city)
      expect(find_field(:state).value).to eq(@user_address.state)
      expect(find_field(:zip).value).to eq(@user_address.zip.to_s)

      nickname = 'Christopher'
      address = '456 1st St'
      city = 'Northglenn'
      state = 'CO'
      zip = 80233

      fill_in "Nickname", with: nickname
      fill_in "Address", with: address
      fill_in "City", with: city
      fill_in "State", with: state
      fill_in "Zip", with: zip
      click_button 'Submit'

      expect(current_path).to eq('/profile')
      within "#address-#{@user_address.id}" do
        expect(page).to have_content(nickname)
        expect(page).to have_content(address)
        expect(page).to have_content(city)
        expect(page).to have_content(state)
        expect(page).to have_content(zip)
      end
    end
  end
end
