require 'spec_helper'

feature "Plans" do
  scenario "creating a plan" do
    visit new_plan_url
    fill_in "Name", with: "mynewplan"
    fill_in "Price", with: "9.99"
    fill_in "Max storage space", with: "5"
    fill_in "Max bandwidth up", with: "100"
    fill_in "Max bandwidth down", with: "100"
    fill_in "Daily shared links quota", with: "100"
    click_button "Add"
    expect(page).to have_content("Plan added successfully")
  end
end