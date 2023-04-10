require 'rails_helper'

RSpec.describe Patron::VotesController, type: :controller do
  let(:vote_properties) { %i[id status event_track_votes is_editable sharing_image square_sharing_image patron] }
  let(:event_properties) { %i[id name subtitle start_date end_date place description fb_pixel google_analytic
                            track_count_for_vote landing_image sharing_image color csv_file ticket_url vote_end_date] }
  # skip request to Youtube
  before(:each) do
    allow(YouTube).to receive(:http_get).and_return YouTubeSuccess.new
  end
  login_user(type: 'Patron')

  describe 'POST #create' do
    let(:event) { create :event, :with_files }
    let(:track_votes) do
      event.event_tracks.map.with_index do |track, index|
        { position: index + 1, event_track_id: track.id, is_top: true }
      end
    end
    let(:vote_params) { { status: :not_shared, event_track_votes_attributes: track_votes } }
    subject { post :create, params: { event_id: event.id, resource: vote_params } }

    it 'responds successfully' do
      subject
      expect(response).to be_successful
    end

    it 'increase Vote count by 1' do
      expect {
        subject
      }.to change(Vote, :count).by 1
    end
    it 'increase EventTrackVotes by votes.count' do
      expect {
        subject
      }.to change(EventTrackVote, :count).by track_votes.size
    end

    context 'create vote for event that start in two days' do
      let(:event) { create :event, :with_files, vote_end_date: Date.today + 2.day }

      it 'responds successfully' do
        subject
        expect(response).to be_successful
      end
    end

    context 'create vote for event, which has expired vote time' do
      let(:event) { create :event, :with_files, vote_end_date: Date.yesterday }

      it 'return validate error' do
        subject
        expect(json_response[:errors]).to eq(vote_is_over: ["you can't vote for this event, time is over"])
      end
    end

    context 'create vote for event, which vote date expired several hours ago' do
      let(:event) { create :event, :with_files, vote_end_date: DateTime.now - 2.hour }

      it 'return validate error' do
        subject
        expect(json_response[:errors]).to eq(vote_is_over: ["you can't vote for this event, time is over"])
      end
    end

    context 'user has already voted' do
      let!(:vote) { create(:vote, patron_id: @user.id, event: event) }

      it 'return permission error, user has already voted' do
        subject
        expect(response.status).to eq 403
      end

      it 'return error message, user can not vote for one event several times' do
        subject
        expect(json_response[:errors]).to eq I18n.t('pundit.event_policy.can_vote?')
      end
    end
  end

  describe 'PUT #update' do
    let!(:vote) { create(:vote, patron_id: @user.id) }

    describe 'change tracks position in user vote' do
      let(:event_track_votes_attributes) do
        vote.event_track_votes.first['position'] = 5
        vote.event_track_votes.last['position'] = 1
        vote.event_track_votes.map {|etv| { event_track_id: etv.event_track_id, position: etv.position } }
      end
      subject do
        put :update, params: { id: vote.id, event_id: vote.event.id, resource: {
            event_track_votes_attributes: event_track_votes_attributes
        }
        }
      end

      it 'change status in vote' do
        event_track_votes_attributes
        subject
        vote.reload
        attributes = vote.event_track_votes.map {|etv| { event_track_id: etv.event_track_id, position: etv.position } }
        expect(event_track_votes_attributes).to eq attributes
      end

      it 'not create new event_track_votes' do
        expect {
          subject
        }.to change(EventTrackVote, :count).by 0
      end

      describe 'update votes to top status' do
        before(:each) do
          event_track_votes_attributes.each {|etv| etv[:is_top] = true }
        end

        it 'change status in vote' do
          event_track_votes_attributes
          subject
          vote.reload
          attributes = vote.event_track_votes
                           .map {|etv| { event_track_id: etv.event_track_id, position: etv.position, is_top: true } }
          expect(event_track_votes_attributes).to eq attributes
        end
      end
    end

    describe 'set new vote status' do

      let(:new_status) { 'shared' }
      subject do
        put :update, params: { id: vote.id, event_id: vote.event.id, resource: { status: new_status } }
      end

      context 'set share status to vote' do
        it 'return new status in response' do
          subject
          expect(json_response[:resource][:status]).to eq new_status
        end

        it 'set new status in db' do
          subject
          vote.reload
          expect(vote.status).to eq new_status
        end

        it 'do not remove event track votes, after status update' do
          expect { subject }.not_to change { vote.event_track_votes.count }
        end
      end

      context 'update shared vote' do
        let!(:vote) { create(:vote, status: :shared) }

        it 'should return permission error' do
          subject
          expect(json_response[:errors]).to eq('You are not authorized to access this action.')
        end
      end
    end
  end

  describe 'GET #show' do
    let(:event) { create(:event, :with_files) }
    let(:vote) { create(:vote, event: event, patron_id: @user.id).make_sharing_images }
    subject { get :show, params: { event_id: vote.event.id, id: vote.id } }

    it 'should return success response' do
      subject
      expect(response).to be_successful
    end

    it 'should resource necessary has field' do
      subject
      expect(json_response[:resource]).to include *vote_properties
    end

    it 'should flag is editable equal true' do
      subject
      expect(json_response[:resource][:is_editable]).to eq true
    end

    it 'should event_track_votes resource necessary has field' do
      subject
      expect(json_response[:resource][:event_track_votes]).to all include(:id, :position, :event_track)
    end

    it 'should event resource necessary has field' do
      subject
      expect(json_response[:resource][:event]).to include *event_properties
    end

    it 'should patron that made vote has necessary field' do
      subject
      expect(json_response[:resource][:patron]).to include(:name, :avatar)
    end

    it 'should return resource with sharing_image url' do
      subject
      expect(json_response[:resource][:sharing_image][:url]).not_to be_empty
    end

    it 'should return resource with square_sharing_image url' do
      subject
      expect(json_response[:resource][:square_sharing_image][:url]).not_to be_empty
    end
  end

  describe 'GET #index' do
    let(:votes) { create_list(:vote, 2, patron_id: @user.id) }
    subject { get :index, params: { event_id: votes.first.event.id } }

    it 'should return success response' do
      subject
      expect(response).to be_successful
    end

    it 'should each resource has field' do
      subject
      expect(json_response[:resources]).to all include :id, :status, :event_track_votes
    end

    it 'should return all votes' do
      subject
      expect(json_response[:resources].size).to eq(Vote.where(patron: @user).count)
    end
  end
end
