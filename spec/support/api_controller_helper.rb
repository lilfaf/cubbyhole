require 'support/oauth_client_helper'

module ApiControllerHelper
  include OAuthClientHelper

  def current_user
    @current_user ||= FactoryGirl.create(:user)
  end

  def oauth_token
    @token ||= oauth_client.password.get_token(current_user.email, current_user.password).token
  end

  def json_response
    JSON.load(response.body)
  end

  def api_get(action, params={}, session=nil, flash=nil)
    api_process(action, params, session, flash, 'GET')
  end

  def api_post(action, params={}, session=nil, flash=nil)
    api_process(action, params, session, flash, 'POST')
  end

  def api_put(action, params={}, session=nil, flash=nil)
    api_process(action, params, session, flash, 'PUT')
  end

  def api_delete(action, params={}, session=nil, flash=nil)
    api_process(action, params, session, flash, 'DELETE')
  end

  def api_process(action, params={}, session=nil, flash=nil, method='GET')
    process(action, method, params.reverse_merge!(format: :json, use_route: :api, access_token: oauth_token), session, flash)
  end

  def assert_parameter_missing!
    expect(response.status).to eq(400)
    expect(json_response['message']).to match(/parameter missing/)
  end

  def assert_forbidden_operation!
    expect(response.status).to eq(403)
    expect(json_response['message']).to eq('An invalid operation was attempted.')
  end

  def assert_not_found!
    expect(response.status).to eq(404)
    expect(json_response['message']).to eq('The record you were looking for could not be found.')
  end

  def assert_invalid_record!
    expect(response.status).to eq(422)
    expect(json_response['message']).to eq('Invalid record. Please fix errors and try again.')
  end
end

RSpec.configure do |config|
  config.include ApiControllerHelper, type: :controller
end
