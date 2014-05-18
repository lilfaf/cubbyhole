require 'spec_helper'

feature "Users" do
  include Warden::Test::Helpers

  let!(:user) { create(:user) }
  let!(:starter_plan) do
    Plan.create!(
      name: 'Starter',
      price: 9.99,
      max_storage_space: 5,
      max_bandwidth_down: 200,
      max_bandwidth_up: 1000,
      daily_shared_links_quota: 3
    )
  end

  before(:each) do
    login_as(user)
  end

  scenario "editing username" do
    visit edit_user_registration_url(user)
    fill_in "Username", with: "newusername"
    fill_in "Current password", with: "12345678"
    click_button "Update"
    expect(page).to have_content("You updated your account successfully")
    expect(page.current_path).to eq(edit_user_registration_path)
  end

  scenario "updating user plan" do
    visit edit_user_registration_url(user)
    select "Starter", from: 'Plan'
    fill_in "Current password", with: "12345678"
    click_button "Update"
    expect(page).to have_content("You updated your account successfully")
    expect(user.reload.plan).to eq(starter_plan)
    expect(page.current_path).to eq(edit_user_registration_path)
  end
end
