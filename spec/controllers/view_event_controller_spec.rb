require 'rails_helper'

RSpec.describe ViewEventsController, type: :controller do
  # skip request to Youtube
  before(:each) do
    allow(YouTube).to receive(:http_get).and_return YouTubeSuccess.new
  end

  describe 'POST #create' do
    let(:user) { create(:user, type: 'Patron') }
    let(:event) { create(:event, :with_files) }
    let(:view_params) { { event_id: event.id, patron_id: user.id, page: :show_page } }

    subject { post :create, params: { resource: view_params } }

    it 'responds successfully' do
      subject
      expect(response).to be_successful
    end

    it 'increase view event count by 1' do
      expect { subject }.to change(ViewEvent, :count).by 1
    end

    describe 'visit page second time' do
      before(:each) { post :create, params: { resource: view_params } }

      it 'not increase view event count' do
        expect { subject }.to change(ViewEvent, :count).by 0
      end

      it 'return success status' do
        subject
        expect(response).to be_successful
      end

    end

    describe 'visit other page' do

      before(:each) do
        post :create, params: { resource: {
            event_id: event.id, patron_id: user.id, page: :vote_page, visitor_uid: '12345-67890'
         }
        }
      end

      it 'increase view event count' do
        expect { subject }.to change(ViewEvent, :count).by 1
      end
    end
  end
end
