require 'spec_helper'

describe RegistrationsController do
  
  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe '#create' do
    context 'with valid user attributes' do
      it 'should generate a token' do
        expect{
          post :create, user: {
            username: 'test',
            email: 'test@test.com',
            password: '12345678',
            password_confirmation: '12345678'
          }
        }.to change{ Doorkeeper::AccessToken.count }.by(1)
      end
    end

    context 'with invalid user attributes' do
      it 'should not generate a token' do
        post :create, user: {}
        expect(Doorkeeper::AccessToken.count).to eq(0)
      end
    end
  end
end
