require 'spec_helper'

feature "Users" do
  include Warden::Test::Helpers

  let!(:user) { create(:user) }

  scenario "uploading an asset" do
    login_as(user)
    user.generate_access_token!
    visit root_url
    attach_file("file", "#{Rails.root}/spec/support/fixtures/rails.png")
    # submit requires phantomjs ?
  end
end
