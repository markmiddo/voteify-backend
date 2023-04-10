require 'rails_helper'

RSpec.describe VotesController, type: :controller do
  # skip request to Youtube
  before(:each) do
    allow(YouTube).to receive(:http_get).and_return YouTubeSuccess.new
  end
  describe 'GET #show' do
    let(:event) { create(:event, :with_files) }
    let(:vote) { create(:vote, event: event) }
    subject { get :show, params: { id: vote.id } }

    it 'should return success response' do
      subject
      expect(response).to be_successful
    end

    it 'should resource necessary has field' do
      subject
      expect(json_response[:resource]).to include :id, :status, :event_track_votes, :sharing_image
    end

    it 'should event_track_votes resource has necessary field' do
      subject
      expect(json_response[:resource][:event_track_votes]).to all include(:id, :position, :event_track)
    end
  end
end

