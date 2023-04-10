require 'rails_helper'

RSpec.describe 'HealthCheckController', type: :request do
  describe 'GET #index' do
    subject { get '/api/health_check' }

    it 'response should be success' do
      subject
      expect(response).to be_successful
      expect(response.body).to eq 'Hello World!'
    end
  end
end
