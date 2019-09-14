require 'rails_helper'

describe "As an Admin User" do
  before :each do
    @admin_user = User.create!(  name: "chris",
      email: "8@gmail.com",
      password: "password",
      role: 3
    )
    @admin_user_address = @admin_user.addresses.create!(address: '123 Main st', city:'Denver', state:'CO', zip:80219)
    @user_1 = User.create!(  name: "alec",
      email: "5@gmail.com",
      password: "password"
    )
    @user_1_address = @user_1.addresses.create!(address: '123 Main st', city:'Denver', state:'CO', zip:80219)
    @user_2 = User.create!(  name: "josh",
      email: "6@gmail.com",
      password: "password"
    )
    @user_2_address = @user_2.addresses.create!(address: '123 Main st', city:'Denver', state:'CO', zip:80219)
    @user_3 = User.create!(  name: "josh",
      email: "7@gmail.com",
      password: "password"
    )
    @user_3_address = @user_3.addresses.create!(address: '123 Main st', city:'Denver', state:'CO', zip:80219)

    visit '/login'

    fill_in :email, with: @admin_user.email
    fill_in :password, with: @admin_user.password

    click_button "Log In"
  end

  it "I can see all the users in the system" do

    visit '/'
    click_link("Users")

    expect(current_path).to eq("/admin/users")
    within "#user-index-#{@user_1.id}" do
      expect(page).to have_content(@user_1.name)
      expect(page).to have_content("Date registered: #{@user_1.created_at}")
      expect(page).to have_content("User type: #{@user_1.role}")
      click_link("#{@user_1.name}")
    end
    expect(current_path).to eq("/admin/users/#{@user_1.id}")

    visit '/admin/users'
    within "#user-index-#{@user_2.id}" do
      expect(page).to have_content(@user_2.name)
      expect(page).to have_content("Date registered: #{@user_2.created_at}")
      expect(page).to have_content("User type: #{@user_2.role}")
      click_link("#{@user_2.name}")
    end
    expect(current_path).to eq("/admin/users/#{@user_2.id}")

    visit '/admin/users'
    within "#user-index-#{@user_3.id}" do
      expect(page).to have_content(@user_3.name)
      expect(page).to have_content("Date registered: #{@user_3.created_at}")
      expect(page).to have_content("User type: #{@user_3.role}")
      click_link("#{@user_3.name}")
    end
    expect(current_path).to eq("/admin/users/#{@user_3.id}")
  end

  it "I can see user profile page" do
    visit("/admin/users/#{@user_3.id}")
    expect(page).to have_content(@user_3.name)
    expect(page).to have_content(@user_3.addresses.first.address)
    expect(page).to have_content(@user_3.addresses.first.city)
    expect(page).to have_content(@user_3.addresses.first.state)
    expect(page).to have_content(@user_3.addresses.first.zip)
    expect(page).to have_content(@user_3.addresses.first.nickname)
    expect(page).to have_content(@user_3.email)
    expect(page).to_not have_content(@user_3.password)
    expect(page).to_not have_link('Edit Profile')
  end
end
