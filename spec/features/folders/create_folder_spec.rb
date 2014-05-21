require 'spec_helper'

feature "Folders" do
  include Warden::Test::Helpers

  let!(:user) { create(:user) }

  scenario "creating a folder", js: true do
    login_as(user)
    visit root_path
    click_button "New Folder"
    fill_in "Name", with: "Test folder"
    click_button "Create"
    within("table") do
      expect(page).to have_content("Test folder")
    end
  end
end
