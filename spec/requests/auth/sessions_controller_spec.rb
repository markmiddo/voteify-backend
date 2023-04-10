require 'rails_helper'

RSpec.describe 'Session', type: :request do
  let!(:user) { create :user, password: 'password', email: 'email@example.com' }

  describe 'POST create' do
    let(:params) { { email: 'email@example.com', password: 'password' } }

    subject { post '/api/auth/sign_in', params: params }

    it 'should be success' do
      subject
      expect(response).to be_successful
    end

    it 'return user data' do
      subject
      expect(json_response).to include(:resource)
    end

    it 'sets header' do
      subject
      expect(response.header['access-token']).to be
    end

    describe 'return errors' do
      let(:params) { { email: 'email1@example.com', password: 'password1' } }

      it 'response should be failed' do
        subject
        expect(response.status).to eq 401
      end

      it 'response should be return errors' do
        subject
        expect(json_response[:errors]).to eq ['Invalid login credentials. Please try again.']
      end
    end
  end

  describe 'DELETE destroy' do

    it 'should destroy session' do
      delete '/api/auth/sign_out', headers: user.create_new_auth_token
      expect(response.header['access-token']).to eq nil
    end
  end
end
