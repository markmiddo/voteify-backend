require 'rails_helper'

RSpec.describe 'TokenValidations', type: :request do
  let(:user) { create :user }

  describe 'GET create' do

    subject { get '/api/auth/validate_token', params: {}, headers: user.create_new_auth_token }

    it 'should be success' do
      subject
      expect(response).to be_successful
    end

    it 'should return correct data' do
      subject
      expect(json_response[:resource][:id]).to eq user.id
    end
  end
end
