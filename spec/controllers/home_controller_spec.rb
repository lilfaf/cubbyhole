require 'spec_helper'

describe HomeController do
  context 'when user is not authenticated' do
    it 'should render the application layout' do
      get :index
      expect(response).to be_succes
      expect(response).to render_template('application')
    end

    it 'should not set user info to javascript' do
      expect(controller).not_to receive(:set_current_user_to_js)
      get :index
    end
  end

  context 'when user is authenticated' do
    let!(:user) { create(:user) }
    before { user.generate_access_token! }

    it 'should render the cubbyhole template' do
      sign_in user
      get :index
      expect(response).to be_succes
      expect(response).to render_template('cubbyhole')
    end

    it 'should set user info to javascript' do
      sign_in user
      expect(controller).to receive(:set_current_user_to_js)
      get :index
    end
  end
end
