require 'spec_helper'

feature "Data Preloading" do
  include Warden::Test::Helpers

  let!(:user) { create(:user) }

  before(:each) do
    login_as(user)
    user.generate_access_token!
  end

  scenario "sets current user info to javascript" do
    visit root_path
    expect(page.body).to have_content('gon.current_user=')
  end
end
