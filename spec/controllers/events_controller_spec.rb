require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  login_user(type: 'Client')
  let(:event_fields) do
    %i(id name subtitle start_date end_date place description ticket_url fb_pixel google_analytic track_count_for_vote
    color landing_image sharing_image event_tracks client square_image facebook_title facebook_description
    share_title share_description text_color top_songs_description shortlist_description vote_end_date)
  end

  before(:each) do
    allow(YouTube).to receive(:http_get).and_return YouTubeSuccess.new
  end

  describe 'GET #index' do
    let(:params) { {} }
    let!(:events) { create_list(:event, 5, :with_files) }
    subject { get :index,  params: params }

    it 'responds successfully' do
      subject
      expect(response).to be_successful
    end

    it 'each object has right fields' do
      subject
      expect(json_response[:resources].size).to be > 0
    end

    it 'should each event to be active' do
      subject
      json_response[:resources].each do |event|
        expect(event[:start_date].to_date).to be >= Date.today
      end
    end

    context 'order' do
      context 'by views' do
        let(:params) { super().merge(order: :views) }
        let!(:view_events) do
          events.map.with_index do |event, index|
            create_list(:view_event, index, event: event)
          end
        end

        it 'should return ordered events' do
          subject
          sorted_views = events.sort_by(&:views_count).reverse.map(&:name)
          expect(json_response[:resources].map {|el| el[:name] }).to eq sorted_views
        end
      end

      context 'by sharing' do
        let(:params) { super().merge(order: :sharing) }
        let!(:shared_events) do
          events.map.with_index do |event, index|
            create_list(:vote, index, event: event, status: 'shared')
          end
        end

        it 'should return ordered events' do
          subject
          sorted_sharing = events.sort_by(&:sharing_count).reverse.map(&:name)
          expect(json_response[:resources].map {|el| el[:name] }).to eq sorted_sharing
        end
      end
    end
  end

  describe 'GET #index with filters' do
    include ActiveSupport::Testing::TimeHelpers
    before(:each) do
      travel_to 5.days.ago
      #create event that start 5 day ago
      create_list(:event, 3, :with_files, client_id: @user.id, start_date: Date.today)
      travel_back
      #create event that start today
      create_list(:event, 2, :with_files, client_id: @user.id, start_date: Date.today)
    end

    context 'date filter with value month' do
      subject { get :index, params: { date_filter: :specified_period, from: 3.day.ago, to: Date.today } }

      it 'return records' do
        subject
        expect(json_response[:resources].size).to eq 2
      end
    end

    context 'specified date filter with not set date' do
      subject { get :index, params: { date_filter: :specified_period } }

      it 'return records that start today' do
        subject
        expect(json_response[:resources].size).to eq 2
      end

      it 'should each event start today' do
        subject
        json_response[:resources].each do |event|
          expect(event[:start_date].to_date).to eq(Date.today)
        end
      end
    end
  end

  describe 'GET #show' do
    login_user(type: 'Patron')
    let(:event) { create(:event, :with_files) }
    subject { get :show, params: { id: event.id } }

    it 'responds successfully' do
      subject
      expect(response).to be_successful
    end

    it 'each object has right fields' do
      subject
      expect(json_response[:resource]).to include *event_fields
    end

    describe 'should return event tracks' do
      let(:event_track_fields) { %i[id event_id track_id star track] }

      it 'each object has right fields' do
        subject
        expect(json_response[:resource][:event_tracks]).to all include *event_track_fields
      end
    end

    describe 'should return client' do
      let(:client_fields) { %i[id name company_name instagram_url fb_url] }

      it 'each object has right fields' do
        subject
        expect(json_response[:resource][:client]).to include *client_fields
      end
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

    context 'user not vote for event' do

      it 'each object has right fields' do
        subject
        expect(json_response[:resource][:ticket_url]).to be_nil
      end
    end

    context 'user vote, but not share result to fb' do
      let(:vote_properties) { %i[id status sharing_image square_sharing_image] }
      let!(:vote) { create(:vote, patron_id: @user.id, event_id: event.id) }

      it 'each object has right fields' do
        subject
        expect(json_response[:resource][:ticket_url]).to be_nil
      end

      it 'return event with vote' do
        subject
        expect(json_response[:resource][:vote]).to include *vote_properties
      end
    end

    context 'user vote and share result to fb' do
      let!(:vote) { create(:vote, patron_id: @user.id, status: :shared, event_id: event.id) }

      it 'each object has right fields' do
        subject
        expect(json_response[:resource][:ticket_url]).not_to be_nil
      end
    end
  end

  after(:all) do
    FileUtils.rm_rf('public/uploads/test/.')
    FileUtils.rm_rf('public/uploads/tmp/.')
  end
end
