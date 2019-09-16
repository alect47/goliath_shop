require 'rails_helper'

describe 'As an Admin' do
  before :each do
    @admin_user = User.create!(  name: "chris",
      email: "8@gmail.com",
      password: "password",
      role: 3
    )
    @admin_user_address = @admin_user.addresses.create!(address: '123 Main st', city:'Denver', state:'CO', zip:80219)
    visit '/login'
    fill_in :email, with: @admin_user.email
    fill_in :password, with: @admin_user.password
    click_button "Log In"
  end

  it 'I cannot visit any path starting with /merchant' do
    visit '/merchant'
    expect(page).to have_content("The page you were looking for doesn't exist (404)")
  end

  it 'I cannot visit any path for the shopping cart' do
    visit '/cart'
    expect(page).to have_content("The page you were looking for doesn't exist (404)")
  end
end
