require 'rails_helper'

describe 'User Registration' do
  describe 'when user clicks on register' do
    it 'they can fill out a form to register new user' do

      visit '/items'

      within 'nav' do
        click_link 'Register'
      end

      expect(current_path).to eq("/register")

      name = "alec"
      address = "234 Main"
      city = "Denver"
      state = "CO"
      zip = 80204
      email = "alec@gmail.com"
      password = "password"
      password_confirmation = "password"

      fill_in "Name", with: name
      fill_in "Address", with: address
      fill_in "City", with: city
      fill_in "State", with: state
      fill_in "Zip", with: zip
      fill_in "Email", with: email
      fill_in "Password", with: password
      fill_in "Confirm Password", with: password_confirmation
      click_button("Submit")

      expect(current_path).to eq("/profile")
      expect(page).to have_content("Welcome, #{name}")
    end

    it 'they have to fill out entire form' do

      visit '/register'

      click_button "Submit"
      # save_and_open_page
      expect(page).to have_content("Name can't be blank")
      expect(page).to have_content("City can't be blank")
      expect(page).to have_content("State can't be blank")
      expect(page).to have_content("Zip can't be blank")
      expect(page).to have_content("Email can't be blank")
      expect(page).to have_content("Password can't be blank")
      expect(page).to have_content("Password digest can't be blank")
      expect(page).to have_content("Address can't be blank")

      expect(current_path).to eq("/users")
    end

    it 'they have to use unique email address' do

      user = User.create!(  name: "alec",
        email: "5@gmail.com",
        password: "password"
      )
      user_address = user.addresses.create!(address: '123 Main st', city:'Denver', state:'CO', zip:80219)


      visit '/register'

      name = "alec"
      address = "234 Main"
      city = "Denver"
      state = "CO"
      zip = 80204
      email = "5@gmail.com"
      password = "password"
      password_confirmation = "password"

      fill_in "Name", with: name
      fill_in "Address", with: address
      fill_in "City", with: city
      fill_in "State", with: state
      fill_in "Zip", with: zip
      fill_in "Email", with: email
      fill_in "Password", with: password
      fill_in "Confirm Password", with: password_confirmation

      click_button "Submit"
      expect(current_path).to eq("/users")
      expect(page).to have_content("Email has already been taken")
      expect(user).to eq(User.last)
      expect(find_field("Name").value).to eq(name)
      expect(find_field("Address").value).to eq(address)
      expect(find_field("City").value).to eq(city)
      expect(find_field("State").value).to eq(state)
      expect(find_field("Zip").value).to eq(zip.to_s)
      expect(find_field("Email").value).to eq(nil)
      expect(find_field("Password").value).to eq(nil)
      expect(find_field("Confirm Password").value).to eq(nil)
    end
  end
end
