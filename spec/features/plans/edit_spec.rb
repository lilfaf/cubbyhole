require 'spec_helper'

feature "Plans" do
  let(:plan) { FactoryGirl.create(:plan) }
  scenario "edit a plan" do
    visit edit_plan_url(plan)
    fill_in "Name", with: "mynewplan"
    fill_in "Price", with: "9.99"
    fill_in "Max storage space", with: "5"
    fill_in "Max bandwidth up", with: "100"
    fill_in "Max bandwidth down", with: "100"
    fill_in "Daily shared links quota", with: "100"
    click_button "Edit"
    expect(page).to have_content("Plan updated successfully")
  end
end