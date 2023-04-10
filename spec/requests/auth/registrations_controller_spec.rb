require 'rails_helper'

RSpec.describe 'Registration', type: :request do

  describe 'POST create' do

    let(:data) do
      {
          name:                  'test user',
          email:                 'user@example.com',
          password:              'password',
          password_confirmation: 'password'
      }
    end

    subject { post '/api/auth', params: data }

    it 'response should be success' do
      subject
      expect(response).to be_successful
    end

    it 'creates new user' do
      expect {
        subject
      }.to change(User, :count).by 1
    end

    it 'return fields' do
      subject
      expect(json_response[:resource]).to include(:id, :name, :email, :avatar)
    end

    describe 'create new client' do
      before(:each) { data[:type] = 'Client' }

      it 'increase Client count by 1' do
        expect {
          subject
        }.to change(Client, :count).by 1
      end
    end

    describe 'create new patron' do
      before(:each) { data[:type] = 'Patron' }

      it 'increase Patron count by 1' do
        expect {
          subject
        }.to change(Patron, :count).by 1
      end
    end

    describe 'create new Admin' do
      before(:each) { data[:type] = 'Admin' }

      it 'not create new user' do
        expect {
          subject
        }.to change(Admin, :count).by 0
      end

      it 'return error' do
        subject
        expect(json_response[:errors]).to eq(type: ['must be accepted'])
      end
    end

    describe 'return errors: email, password' do
      let(:data) { { password: '', email: '' } }

      it 'response should be failed' do
        subject
        expect(response.status).to eq 422
      end

      it 'response should be return errors' do
        subject
        expect(json_response[:errors]).to eq(password: ["can't be blank"], email: ["can't be blank"])
      end

      it 'too_short password error' do
        post '/api/auth', params: { password: '12', email: 'email@ek.com' }
        expect(json_response[:errors]).to eq(password: ['Oops too short. At least 6 characters please?'])
      end
    end
  end

  describe 'DELETE destroy' do
    let!(:user) { create(:user) }
    subject { delete '/api/auth/', headers: user.create_new_auth_token }

    it 'should return success status' do
      subject
      expect(response.status).to eq(200)
    end

    it 'should decrease user count' do
      expect { subject }.to change(User, :count).by -1
    end
  end
end
