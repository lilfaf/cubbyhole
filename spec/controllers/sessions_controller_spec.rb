require 'spec_helper'

describe SessionsController do
  let(:user) { create(:user) }

  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe '#create' do
    context 'with invalid credentials' do
      it 'should generate a token' do
        expect{
          post :create, user: { login: 'test', password: '123' }
        }.not_to change{ Doorkeeper::AccessToken.count }
      end
    end

    context 'with valid credentials' do
      it 'should generate a token' do
        expect{
          post :create, user: { login: user.email, password: user.password }
        }.to change { Doorkeeper::AccessToken.count }.by(1)
      end
    end
  end

  describe '#destroy' do
    it 'should revoke the auth token' do
      sign_in(user)
      user.generate_access_token!
      expect{ delete :destroy }.to change{ Doorkeeper::AccessToken.count }.by(-1)
    end
  end
end
