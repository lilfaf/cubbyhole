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

  scenario "editing username" do
    login_as(user)
    visit edit_user_registration_url(user)
    fill_in "Username", with: "newusername"
    fill_in "Current password", with: "12345678"
    click_button "Update"
    expect(page).to have_content("You updated your account successfully")
  end

  scenario "updating user plan" do
    login_as(user)
    visit edit_user_registration_url(user)
    select "Starter", from: 'Plan'
    fill_in "Current password", with: "12345678"
    click_button "Update"
    expect(page).to have_content("You updated your account successfully")
    expect(user.reload.plan).to eq(starter_plan)
  end
end
