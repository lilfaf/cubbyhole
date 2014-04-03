require 'spec_helper'

feature "Users" do
  include Warden::Test::Helpers

  let!(:user) { create(:user) }

  scenario "uploading a file" do
    login_as(user)
    visit app_url
    attach_file("asset_image", "#{Rails.root}/spec/support/fixtures/rails.png")
  end
end
