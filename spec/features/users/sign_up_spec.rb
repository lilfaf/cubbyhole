require 'spec_helper'

feature "Users" do
  scenario "creating a user" do
    visit new_user_registration_url
    fill_in "Username", with: "myusername"
    fill_in "Email", with: "test@example.com"
    fill_in "Password", with: "12345678"
    fill_in "Password confirmation", with: "12345678"
    click_button "Sign up"
    expect(page).to have_content("Welcome! You have signed up successfully")
  end
end
