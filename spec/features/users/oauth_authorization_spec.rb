require 'spec_helper'

feature 'Oauth authorization' do
  include OAuthClientHelper

  let!(:user) { create(:user) }

  scenario 'authentication succeed with email and password' do
    token = oauth_client.password.get_token(user.email, user.password)
    expect(token).not_to be_expired
  end

  scenario 'authentication succeed with username and password' do
    token = oauth_client.password.get_token(user.username, user.password)
    expect(token).not_to be_expired
  end

  scenario 'authentication fails' do
    expect{oauth_client.password.get_token(user.email, '123')}.to raise_error(OAuth2::Error)
  end
end
