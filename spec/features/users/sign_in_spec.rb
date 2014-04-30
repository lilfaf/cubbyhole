require 'spec_helper'

feature "Users" do
  let(:user) { create(:user) }
  let(:admin) { create(:admin) }

  context "as an member" do
    scenario "sign in a user with username and password" do
      visit new_user_session_url
      fill_in "Login", with: user.username
      fill_in "Password", with: "12345678"
      click_button "Sign in"
      expect(page).to have_content("Signed in successfully")
      expect(page.current_path).to eq(root_path)
    end

    scenario "sign in a user with email and password" do
      visit new_user_session_url
      fill_in "Login", with: user.email
      fill_in "Password", with: "12345678"
      click_button "Sign in"
      expect(page).to have_content("Signed in successfully")
      expect(page.current_path).to eq(root_path)
    end
  end

  context "as an admin" do
    scenario "sign in to admin fail with member credentials" do
      visit admin_root_path
      fill_in "Login", with: admin.username
      fill_in "Password", with: "12345678"
      click_button "Sign in"
      expect(page.current_path).to eq(admin_root_path)
    end
  end
end
