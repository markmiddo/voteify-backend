require 'rails_helper'

RSpec.describe VisitorMessagesController, type: :controller do

  describe 'POST #create' do
    subject { post :create, params: { resource: message_params } }


    context 'valid visitor message  params' do
      let(:message_params) { { email: Faker::Internet.email, message_text: Faker::Lorem.paragraph } }

      it 'responds successfully' do
        subject
        expect(response).to be_successful
      end

      it 'increase Contact count by 1' do
        expect {
          subject
        }.to change(VisitorMessage, :count).by 1
      end

      it 'should sent email' do
        expect { subject }.to change { ActionMailer::Base.deliveries.count }.by(1)
      end

      it 'should sent email to correct email' do
        subject
        expect(ActionMailer::Base.deliveries.first.to.first).to eq(ENV['ADMIN_EMAIL'])
      end
    end

    context 'invalid visitor message params' do

      context 'empty_params' do
        let(:message_params) { {} }

        it 'responds with error' do
          subject
          expect(json_response[:errors]).to eq('param is missing or the value is empty: resource')
        end
      end

      context 'invalid email' do
        let(:message_params) { { email: 'test', message_text: Faker::Lorem.paragraph } }

        it 'responds with error' do
          subject
          expect(json_response[:errors]).to eq({ email: ['is not an email'] })
        end
      end
    end
  end
end
