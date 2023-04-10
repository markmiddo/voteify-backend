require 'rails_helper'

RSpec.describe Client::EventsController, type: :controller do
  login_user(type: 'Client')

  before(:each) do
    allow(YouTube).to receive(:http_get).and_return YouTubeSuccess.new
  end

  describe 'GET #index' do
    let(:event_fields) do
      %i[id name start_date end_date landing_image place votes_count]
    end

    describe 'index page without filters' do
      let!(:events) { create_list(:event, 5, :with_files, client_id: @user.id) }
      subject { get :index }

      it 'responds successfully' do
        subject
        expect(response).to be_successful
      end

      it 'each object has right fields' do
        subject
        expect(json_response[:resources]).to all include *event_fields
      end

      it 'return records' do
        subject
        expect(json_response[:resources].size).to be > 0
      end

      describe 'pagination' do

        it 'limit' do
          get :index, params: { limit: 3, offset: 2 }
          expect(json_response[:resources].size).to eq 3
        end

        it 'offset' do
          get :index, params: { limit: 3, offset: 3 }
          expect(json_response[:resources].size).to eq 2
        end
      end

      describe 'order' do
        describe 'name' do
          before(:each) do
            events.each_with_index {|event, index| event.update_attribute(:name, index) }
          end

          it 'right values' do
            get :index, params: { order: :name, limit: 3, offset: 1 }
            expect(json_response[:resources].map {|r| r[:name] }).to eq(%w(1 2 3))
          end
        end

        describe 'start_date' do
          before(:each) do
            events.each_with_index do |event, index|
              event.update_attribute(:start_date, Date.parse('24-09-2018') - index.day)
            end
          end

          it 'right values' do
            get :index, params: { order: :start_date, limit: 3, offset: 1 }
            date = %w(2018-09-23T00:00:00.000Z 2018-09-22T00:00:00.000Z 2018-09-21T00:00:00.000Z)
            expect(json_response[:resources].map {|r| r[:start_date] }).to eq(date)
          end
        end

        describe 'end_date' do
          before(:each) do
            events.each_with_index do |event, index|
              event.update_attribute(:end_date, Date.parse('24-09-2018') - index.day)
            end
          end

          it 'right values' do
            get :index, params: { order: :end_date, limit: 3 }
            date = %w(2018-09-24T00:00:00.000Z 2018-09-23T00:00:00.000Z 2018-09-22T00:00:00.000Z)
            expect(json_response[:resources].map {|r| r[:end_date] }).to eq(date)
          end
        end
      end
    end

    describe 'index page with date filter' do
      include ActiveSupport::Testing::TimeHelpers

      context 'date filter with value week' do
        before(:each) do
          travel_to 3.days.ago
          #create event which took place last week
          create_list(:event, 10, :with_files, client_id: @user.id, start_date: Date.today)
          travel_to 30.days.ago
          #create event which took place very long ago
          create_list(:event, 10, :with_files, client_id: @user.id, start_date: Date.today)
          travel_back
        end

        subject { get :index, params: { date_filter: :week } }

        it 'return records' do
          subject
          expect(json_response[:resources].size).to eq 10
        end

        it 'each record has correct start date' do
          subject
          json_response[:resources].each do |event|
            expect(event[:start_date].to_date).to be_between(1.week.ago, Date.today)
          end
        end

      end

      context 'date filter with value month' do
        before(:each) do
          travel_to 15.days.ago
          #create event which took place last month
          create_list(:event, 10, :with_files, client_id: @user.id, start_date: Date.today)
          travel_to 60.days.ago
          #create event which took place very long ago
          create_list(:event, 10, :with_files, client_id: @user.id, start_date: Date.today)
          travel_back
        end

        subject { get :index, params: { date_filter: :month } }

        it 'return records' do
          subject
          expect(json_response[:resources].size).to eq 10
        end

        it 'each record has correct start date' do
          subject
          json_response[:resources].each do |event|
            expect(event[:start_date].to_date).to be_between(1.month.ago, Date.today)
          end
        end
      end

      context 'date filter with value month' do
        before(:each) do
          #create event which took place today
          create_list(:event, 10, :with_files, client_id: @user.id, start_date: Date.today)
          travel_to 5.days.ago
          #create event which took place very long ago
          create_list(:event, 10, :with_files, client_id: @user.id, start_date: Date.today)
          travel_back
        end

        subject { get :index, params: { date_filter: :day } }

        it 'return records' do
          subject
          expect(json_response[:resources].size).to eq 10
        end

        it 'each record has correct start date' do
          subject
          json_response[:resources].each do |event|
            expect(event[:start_date].to_date).to eq(Date.today)
          end
        end
      end
    end
  end


  describe 'GET #show' do
    let(:event_fields) do
      %i(id name subtitle start_date end_date place description ticket_url fb_pixel google_analytic track_count_for_vote
    color landing_image sharing_image votes_count votes_shared_count event_show_page_visit_count
    event_vote_page_visit_count votes)
    end
    let(:event) { create(:event, :with_files, client_id: @user.id) }
    subject { get :show, params: { id: event.id } }

    it 'responds successfully' do
      subject
      expect(response).to be_successful
    end

    it 'each object has right fields' do
      subject
      expect(json_response[:resource]).to include *event_fields
    end

    context 'votes for event' do
      let!(:votes) { create_list(:vote, 3, event: event) }

      it 'should return all votes for event' do
        subject
        expect(json_response[:resource][:votes].size).to eq votes.size
      end

      it 'should votes has correct fields' do
        subject
        expect(json_response[:resource][:votes]).to all include :patron, :status, :updated_at
      end
    end

    describe 'get event_tracks statistic - vote_count and vote_points' do
      let(:votes) { create_list(:vote, 3, event: event.id) }

      it 'should return statistic fields' do
        subject
        tracks = json_response[:resource][:event_tracks]
        tracks.each do |track|
          expect(track).to include(:vote_count, :vote_points)
        end
      end
    end
    describe 'show event other client' do
      let(:event) { create(:event, :with_files, client_id: create(:client).id) }

      it 'should return errors' do
        subject
        expect(json_response[:errors]).to eq('You are not authorized to access this action.')
      end
    end
  end

  describe 'POST #create' do

    context 'with valid data' do
      let(:event_attribute) { { resource: attributes_for(:event, :with_files) } }
      subject { post :create, params: event_attribute }

      it 'responds successfully' do
        subject
        expect(response).to be_successful
      end

      it 'increase Event count by 1' do
        expect { subject }.to change(Event, :count).by 1
      end

      describe 'landing page image' do
        it 'return all images with different size' do
          subject
          expect(json_response[:resource][:landing_image][:url]).to be
          expect(json_response[:resource][:landing_image][:very_small]).to be
          expect(json_response[:resource][:landing_image][:small]).to be
          expect(json_response[:resource][:landing_image][:medium]).to be
        end
      end
    end

    context 'with empty data' do
      subject { post :create, params: {} }

      it 'responds with bad request_status' do
        subject
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'width invalid date' do
      let(:event_attribute) { { resource: attributes_for(:event, :with_files, start_date: '', end_date: '') } }
      subject { post :create, params: event_attribute }

      it 'do not increase Event count' do
        expect { subject }.to change(Event, :count).by 0
      end

      it 'return error message' do
        subject
        expect(json_response[:errors]).to eq(start_date: ["can't be blank"], end_date: ["can't be blank"])
      end
    end

    describe 'Active job task' do
      let(:event_attribute) { { resource: attributes_for(:event, :with_files) } }
      subject { post :create, params: event_attribute }
      it 'should new job created' do
        expect { subject }.to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by 1
      end
      it 'should create job for correct event' do
        subject
        expect(ActiveJob::Base.queue_adapter.enqueued_jobs.last[:args].first).to eq(json_response[:resource][:id])
      end
      it 'should create job with correct type' do
        subject
        expect(ActiveJob::Base.queue_adapter.enqueued_jobs.first[:job]).to eq(TrackLoaderJob)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:event) { create(:event, :with_files, client_id: @user.id) }
    subject { delete :destroy, params: { id: event.id } }

    describe 'user delete own event' do

      it 'responds successfully' do
        subject
        expect(response).to be_successful
      end

      it 'increase Event count by -1' do
        expect {
          subject
        }.to change(Event, :count).by -1
      end
    end

    describe 'user delete other user event' do
      login_user(type: 'Client')

      it 'should return errors' do
        subject
        expect(json_response[:errors]).to eq('You are not authorized to access this action.')
      end

      it 'should event not deleted' do
        expect { subject }.to change(Event, :count).by 0
      end
    end

  end

  describe 'PUT #update' do
    let(:event) { create(:event, :with_files, client_id: @user.id) }
    let(:new_params) do
      {
          name:        'new name',
          description: 'desciption',
          place:       'Sumy'
      }
    end
    subject { put :update, params: { id: event.id, resource: new_params } }

    it 'responds successfully' do
      subject
      expect(response).to be_successful
    end

    it 'should change event fields' do
      subject
      expect(json_response[:resource][:name]).to eq(new_params[:name])
      expect(json_response[:resource][:place]).to eq(new_params[:place])
      expect(json_response[:resource][:description]).to eq(new_params[:description])
    end
  end

  after(:all) do
    FileUtils.rm_rf('public/uploads/test/.')
    FileUtils.rm_rf('public/uploads/tmp/.')
  end
end
