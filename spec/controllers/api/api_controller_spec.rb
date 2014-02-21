require 'spec_helper'

describe Api::ApiController do
  controller(Api::ApiController) do
    def index
      render json: { message: 'greetings' }
    end
  end

  context "as an authenticated user" do
    it "can make a request" do
      api_get :index
      expect(response.status).to eq(200)
      expect(json_response['message']).to eq('greetings')
    end
  end

  context "as an unauthorized user" do
    it "should respond with 401 unauthorized access" do
      get :index, use_route: :api
      expect(response.status).to eq(401)
      expect(response.headers['WWW-Authenticate']).to match(/The access token is invalid/)
    end
  end
end
