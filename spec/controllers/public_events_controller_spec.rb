require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  let(:public_event_properties) do
    %i[id name subtitle start_date end_date place description ticket_url fb_pixel
     google_analytic landing_image color square_image top_songs_description track_count_for_vote shortlist_description
     facebook_title facebook_description vote_end_date
    ]
  end

  before(:each) do
    allow(YouTube).to receive(:http_get).and_return YouTubeSuccess.new
  end


  describe 'GET #show with authenticated user' do
      let(:event) { create(:event, :with_files) }
      subject { get :show, params: { id: event.id } }

      it 'responds successfully' do
        subject
        expect(response).to be_successful
      end

      it 'each object has right fields' do
        subject
        expect(json_response[:resource]).to include *public_event_properties
      end

      describe 'tracks ordering' do
        before(:each) do
          tracks_count = event.tracks.size
          event.tracks.each_with_index do |track, index|
            new_name = "author#{tracks_count - index}"
            track.update(author: new_name)
          end
        end
        let(:new_names) do
          Array.new(event.tracks.count) {|i| "author#{i + 1}" }
        end

        it 'tracks should be sorted by author' do
          subject
          author_names = json_response[:resource][:event_tracks].map do |event_tracks|
            event_tracks[:track][:author]
          end
          expect(new_names).to eq author_names
        end
      end
  end


  after(:all) do
    FileUtils.rm_rf('public/uploads/test/.')
    FileUtils.rm_rf('public/uploads/tmp/.')
  end
end
