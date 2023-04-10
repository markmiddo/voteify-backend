require 'rails_helper'

RSpec.describe EventTracksController, type: :controller do

  before(:each) do
    allow(YouTube).to receive(:http_get).and_return YouTubeSuccess.new
  end

  let(:event_track_properties) { %i[id event_id track_id track star] }
  let(:track_properties) { %i[id author title published_at thumbnails youtube_title video_id] }

  describe 'Unauthenticated request' do
    describe 'POST #create' do
      let!(:event) { create :event, :with_files }
      let(:params) { { resource: { event_id: event.id, author: 'Selfy', title: 'Galya' } } }

      subject { post :create, params: params }

      it 'responds successfully' do
        subject
        expect(response).to be_successful
      end

      it 'increase event track count by 1' do
        expect { subject }.to change{ event.event_tracks.count }.by 1
      end

      it 'return required properties' do
        subject
        expect(json_response[:resource]).to include *event_track_properties
      end

      it 'return event track NOT marked with a star' do
        subject
        expect(json_response[:resource][:star]).to be_falsey
      end

      it 'return required track properties' do
        subject
        expect(json_response[:resource][:track]).to include *track_properties
      end

      context 'whitespaces inside author name and title' do
        let(:params) { { resource: { event_id: event.id, author: "Selfy\r\n", title: "Galya\r\n" } } }

        it 'responds successfully' do
          subject
          expect(response).to be_successful
        end

        it 'strip whitespaces from track title before saving' do
          subject
          expect(json_response[:resource][:track][:title]).to eq params.dig(:resource, :title).strip
        end

        it 'strip whitespaces from author before saving' do
          subject
          expect(json_response[:resource][:track][:author]).to eq params.dig(:resource, :author).strip
        end
      end
    end
  end

  describe 'Client' do
    login_user type: 'Client'

    describe 'POST #create' do
      let!(:event) { create :event, :with_files }
      let(:params) { { resource: { event_id: event.id, author: 'Selfy', title: 'Galya' } } }

      subject { post :create, params: params }

      it 'responds with permission error, client can not create tracks' do
        subject
        expect(response.status).to eq 403
      end
    end

    describe 'DELETE #destroy' do
      let!(:event) { create :event, :with_files, client_id: @user.id }
      let!(:track) { create :track, author: 'Selfy', title: 'Galya', video_id: '11111' }
      let!(:event_track) { create :event_track, event: event, track: track }

      subject { post :destroy, params: { id: event_track.id } }

      it 'responds successfully' do
        subject
        expect(response.status).to eq 200
      end

      it 'destroy event_track' do
        expect{ subject }.to change(EventTrack, :count).by -1
      end

      describe 'delete alien track' do
        let!(:event) { create :event, :with_files, client: (create :client) }

        it 'forbidden' do
          subject
          expect(response.status).to eq 403
        end
      end
    end
  end

  describe 'Patron' do
    login_user type: 'Patron'

    describe 'POST #create' do
      let!(:event) { create :event, :with_files }
      let(:params) { { resource: { event_id: event.id, author: 'Selfy', title: 'Galya' } } }

      subject { post :create, params: params }

      describe 'success create' do

        it 'responds successfully' do
          subject
          expect(response).to be_successful
        end

        it 'increase event track count by 1' do
          expect { subject }.to change{ event.event_tracks.count }.by 1
        end

        it 'return fields required properties' do
          subject
          expect(json_response[:resource]).to include *event_track_properties
        end

        it 'return event track marked with a star' do
          subject
          expect(json_response[:resource][:star]).to be_truthy
        end

        it 'return required track properties' do
          subject
          expect(json_response[:resource][:track]).to include *track_properties
        end

        describe 'track already exists with this author and this title' do
          let!(:track) { create :track, author: 'Selfy', title: 'Galya', video_id: '11111' }

          it 'increase event track count by 1' do
            expect { subject }.to change{ event.event_tracks.count }.by 1
          end

          it 'not create track' do
            expect { subject }.to change(Track, :count).by 0
          end
        end

        describe 'track already exists with this video_id' do
          let!(:track) { create :track, author: 'Selfy_1', title: 'Galya_1', video_id: '2222' }

          before(:each) do
            allow(YouTube).to receive(:http_get).and_return YouTubeSuccess.new(video_ids: ['2222'])
          end

          it 'increase event track count by 1' do
            expect { subject }.to change{ event.event_tracks.count }.by 1
          end

          it 'not create track' do
            expect { subject }.to change(Track, :count).by 0
          end
        end

        describe 'event_track already exists' do
          let!(:track) { create :track, author: 'Selfy', title: 'Galya', video_id: '3333' }
          let!(:event_track) { create :event_track, event: event, track: track }

          it 'increase event track count by 0' do
            expect { subject }.to change{ event.event_tracks.count }.by 0
          end

          it 'return error message' do
            subject
            expect(json_response[:errors]).to eq(track: ['has already been taken'])
          end
        end

        describe 'create track with author and title in other register case' do
          let!(:track) { create :track, author: 'SELFY', title: 'GALYA', video_id: '3333' }
          let!(:event_track) { create :event_track, event: event, track: track }

          it 'increase event track count by 0' do
            expect { subject }.to change{ event.event_tracks.count }.by 0
          end

          it 'return error message' do
            subject
            expect(json_response[:errors]).to eq(track: ['has already been taken'])
          end
        end
      end

      describe 'fail create' do
        before(:each) do
          allow(YouTube).to receive(:http_get).and_return YouTubeError.new
        end

        it 'return error status' do
          subject
          expect(response).to_not be_successful
        end

        it 'return error message' do
          subject
          expect(json_response[:errors]).to eq 'YouTube: Bad Request'
        end
      end
    end

    describe 'DELETE #destroy' do
      let!(:event) { create :event, :with_files, client: (create :client) }
      let!(:track) { create :track, author: 'Selfy', title: 'Galya', video_id: '11111' }
      let!(:event_track) { create :event_track, event: event, track: track, patron_id: @user.id }

      subject { post :destroy, params: { id: event_track.id } }

      it 'forbidden' do
        subject
        expect(response.status).to eq 403
      end
    end
  end

  after(:all) do
    FileUtils.rm_rf('public/uploads/test/.')
    FileUtils.rm_rf('public/uploads/tmp/.')
  end
end
