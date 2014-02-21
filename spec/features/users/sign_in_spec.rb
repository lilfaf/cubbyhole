require 'spec_helper'

feature "Users" do
  let!(:user) { create(:user) }

  scenario "sign in a user with username and password" do
    visit new_user_session_url
    fill_in "Login", with: user.username
    fill_in "Password", with: "12345678"
    click_button "Sign in"
    expect(page).to have_content("Signed in successfully")
  end

  scenario "sign in a user with email and password" do
    visit new_user_session_url
    fill_in "Login", with: user.email
    fill_in "Password", with: "12345678"
    click_button "Sign in"
    expect(page).to have_content("Signed in successfully")
  end
end
