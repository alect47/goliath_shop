require 'rails_helper'

describe "User Profile Addresses" do
  describe "As a registered user" do
    before :each do
      @user = User.create!(  name: "alec",
        email: "5@gmail.com",
        password: "password"
      )
      @user_address = @user.addresses.create!(address: '123 Main st', city:'Zion', state:'UT', zip:80204)
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
      expect(find_field("Nickname").value).to eq(@user_address.nickname)
      expect(find_field("Address").value).to eq(@user_address.address)
      expect(find_field("City").value).to eq(@user_address.city)
      expect(find_field("State").value).to eq(@user_address.state)
      expect(find_field("Zip").value).to eq(@user_address.zip.to_s)

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
        expect(page).to_not have_content(@user_address.address)
        expect(page).to have_content(address)
        expect(page).to have_content(city)
        expect(page).to have_content(state)
        expect(page).to have_content(zip)
      end
    end

    it 'they must fill out entire form' do
      visit '/profile'

      within "#address-#{@user_address.id}" do
        click_link "Edit"
      end
      expect(current_path).to eq("/profile/addresses/#{@user_address.id}/edit")
      nickname = 'Christopher'
      address = '456 1st St'
      city = 'Northglenn'
      state = 'CO'
      zip = 80233

      fill_in "Nickname", with: ""
      fill_in "Address", with: ""
      fill_in "City", with: ""
      fill_in "State", with: ""
      fill_in "Zip", with: ""
      click_button 'Submit'
      expect(current_path).to eq("/profile/addresses/#{@user_address.id}")
      expect(page).to have_content("Nickname can't be blank, Address can't be blank, City can't be blank, State can't be blank, Zip can't be blank, Zip is the wrong length")
    end

    it 'They can create new address' do
      visit '/profile'
      click_link "New Address"

      expect(current_path).to eq("/profile/addresses/new")

      nickname = 'Gus'
      address = '123 kitkat ln'
      city = 'Murder'
      state = 'CO'
      zip = 80233

      fill_in "Nickname", with: nickname
      fill_in "Address", with: address
      fill_in "City", with: city
      fill_in "State", with: state
      fill_in "Zip", with: zip
      click_button 'Submit'

      expect(current_path).to eq("/profile")
      new_address = Address.last
      expect(page).to have_content("New Address Added")
      within "#address-#{new_address.id}" do
        expect(page).to have_content(nickname)
        expect(page).to have_content(address)
        expect(page).to have_content(city)
        expect(page).to have_content(state)
        expect(page).to have_content(zip)
      end
    end

    it 'They must fill out entire new address form' do
      visit '/profile'
      click_link "New Address"

      expect(current_path).to eq("/profile/addresses/new")

      nickname = ''
      address = ''
      city = ''
      state = ''
      zip = nil

      fill_in "Nickname", with: nickname
      fill_in "Address", with: address
      fill_in "City", with: city
      fill_in "State", with: state
      fill_in "Zip", with: zip
      click_button 'Submit'

      expect(current_path).to eq("/profile/addresses")
      expect(page).to have_content("Nickname can't be blank, Address can't be blank, City can't be blank, State can't be blank, Zip can't be blank, Zip is the wrong length (should be 5 characters), and Zip is not a number")
    end

    it 'user can delete address' do
      visit '/profile'
      within "#address-#{@user_address.id}" do
        click_link "Delete"
      end

      expect(current_path).to eq("/profile")
      expect(page).to_not have_content(@user_address.address)
      expect(page).to_not have_content(@user_address.city)
      expect(page).to_not have_content(@user_address.state)
      expect(page).to_not have_content(@user_address.zip)
    end

    it "user can't edit/delete address if used in shipped order" do
      @order_4 = @user.orders.create!(address_id: @user_address.id, status: 2)

      visit '/profile'
      within "#address-#{@user_address.id}" do
        click_link "Delete"
      end
      expect(page).to have_content("Sorry you can't delete this address as it is currently being use in an order")

      within "#address-#{@user_address.id}" do
        click_link "Edit"
      end
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
      expect(page).to have_content("Sorry you can't edit this address as it is currently being use in an order")
    end

    it "user can change shipping address of pending order" do
      @order_4 = @user.orders.create!(address_id: @user_address.id, status: 2)

      visit '/profile'
      within "#address-#{@user_address.id}" do
        click_link "Delete"
      end
      expect(page).to have_content("Sorry you can't delete this address as it is currently being use in an order")

      within "#address-#{@user_address.id}" do
        click_link "Edit"
      end
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
      expect(page).to have_content("Sorry you can't edit this address as it is currently being use in an order")
    end
  end
end
