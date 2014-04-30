require 'spec_helper'

describe HomeController do
  context 'when user is not authenticated' do
    it 'should render the application layout' do
      get :index
      expect(response).to be_succes
      expect(response).to render_template('application')
    end
  end

  context 'when user is authenticated' do
    it 'should render cubbyhole template' do
      sign_in create(:user)
      get :index
      expect(response).to be_succes
      expect(response).to render_template('cubbyhole')
    end
  end
end
