require 'spec_helper'

describe MainController do

  before do
    # stub devise authentication
    user = create(:user)
    allow_message_expectations_on_nil
    request.env['warden'].stub :authenticate! => user
    controller.stub :current_user => user
  end

  it "should render angular template" do
    get :index
    expect(response).to be_succes
    expect(response).to render_template("angular")
  end

  it "should verify csrf authenticity token" do
    expect(controller).to receive(:verified_request?).and_return(true)
    get :index
  end

  it "should set csrf token in a cookie" do
    ActionController::Base.allow_forgery_protection = true
    get :index
    response.cookies['XSRF-TOKEN'].should_not be_nil
    ActionController::Base.allow_forgery_protection = false
  end
end
