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
    let!(:user) { create(:user) }

    it 'should redirect to folders path' do
      sign_in user
      get :index
      expect(response).to redirect_to(folders_path)
    end
  end
end
