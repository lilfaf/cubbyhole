require 'spec_helper'

feature "Users" do
  include Warden::Test::Helpers

  scenario "editing username" do
    user = create(:user)
    login_as(user)
    visit edit_user_registration_url(user)
    fill_in "Username", with: "newusername"
    fill_in "Current password", with: "12345678"
    click_button "Update"
    expect(page).to have_content("You updated your account successfully")
  end
end
