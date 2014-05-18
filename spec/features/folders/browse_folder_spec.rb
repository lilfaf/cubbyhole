require 'spec_helper'

feature "Users" do
  include Warden::Test::Helpers

  let!(:user) { create(:user) }
  let!(:folder) { create(:folder, user: user) }

  scenario "uploading an asset", js: true do
    login_as(user)
    visit root_path
    find("#folder-#{folder.id}").click
    expect(page.current_path).to eq(folder_path(folder))
    within(".breadcrumbs") do
      expect(page).to have_content "ROOT"
      expect(page).to have_content folder.name.upcase
    end
  end
end
