require 'spec_helper'

feature "Users" do
  include Warden::Test::Helpers

  let!(:user) { create(:user) }

  scenario "uploading an asset", js: true do
    login_as(user)
    visit root_path
    click_button 'Upload'
    attach_file("file", "#{Rails.root}/spec/support/fixtures/rails.png")

    # TODO
  end
end
