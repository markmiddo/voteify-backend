require 'rails_helper'

RSpec.describe Client::StatisticsController, type: :controller do

  before(:each) do
    allow(YouTube).to receive(:http_get).and_return YouTubeSuccess.new
  end

  describe 'client' do
    login_user(type: 'Client')

    describe 'GET #index' do
      subject { get :index }

      it 'responds successfully' do
        subject
        expect(response).to be_successful
      end

      describe 'return right data' do
        let!(:event1) { create(:event, :with_files, client_id: @user.id) }
        let!(:event2) { create(:event, :with_files, client_id: @user.id) }
        let!(:other_event) { create(:event, :with_files, client: (create :client)) }

        # Monday
        # hours 00
        let!(:other_vote1) { create :vote, event: other_event, created_at: '2018-09-17 00:31' }

        let!(:m_vote1) { create :vote, event: event1, created_at: '2018-09-17 00:31' }
        let!(:m_vote2) { create :vote, event: event2, created_at: '2018-09-17 00:45' }
        let!(:m_vote3) { create :vote, event: event1, created_at: '2017-06-05 00:10' }
        let!(:m_vote4) { create :vote, event: event2, created_at: '2017-05-01 00:20' }

        # hours 01
        let!(:m_vote5) { create :vote, event: event2, created_at: '2018-09-17 01:45' }
        let!(:m_vote6) { create :vote, event: event1, created_at: '2017-06-05 01:10' }
        let!(:m_vote7) { create :vote, event: event2, created_at: '2017-05-01 01:20' }

        # hours 23
        let!(:m_vote8) { create :vote, event: event2, created_at: '2018-09-17 23:45' }
        let!(:m_vote9) { create :vote, event: event1, created_at: '2017-06-05 23:00' }

        # Tuesday
        # hours 00
        let!(:other_vote2) { create :vote, event: other_event, created_at: '2018-09-18 00:31' }

        let!(:t_vote1) { create :vote, event: event1, created_at: '2018-09-18 00:31' }
        let!(:t_vote2) { create :vote, event: event2, created_at: '2018-09-18 00:45' }
        let!(:t_vote3) { create :vote, event: event1, created_at: '2017-06-06 00:10' }
        let!(:t_vote4) { create :vote, event: event2, created_at: '2017-05-02 00:20' }

        # hours 01
        let!(:t_vote5) { create :vote, event: event2, created_at: '2018-09-18 01:45' }
        let!(:t_vote6) { create :vote, event: event1, created_at: '2017-06-06 01:10' }

        # hours 23
        let!(:t_vote7) { create :vote, event: event2, created_at: '2018-09-18 23:45' }

        let(:hours) { 24.times.map{|i| { hour: i, count:0 } } }

        it 'return best result' do
          subject
          expect(json_response[:best_result]).to eq(day: { day: 1, count: 9 }, time: { hour: 0, count: 4 })
        end

        it 'other day data' do
          subject
          expect(json_response[:data][0]).to eq(day: 0, count: 0, hours: hours)
          expect(json_response[:data][3]).to eq(day: 3, count: 0, hours: hours)
          expect(json_response[:data][4]).to eq(day: 4, count: 0, hours: hours)
          expect(json_response[:data][5]).to eq(day: 5, count: 0, hours: hours)
          expect(json_response[:data][6]).to eq(day: 6, count: 0, hours: hours)
        end

        it 'monday data' do
          subject
          hours[0] = { hour: 0, count: 4 }
          hours[1] = { hour: 1, count: 3 }
          hours[23] = { hour: 23, count: 2 }
          expect(json_response[:data][1]).to eq(day: 1, count: 9, hours: hours)
        end

        it 'tuesday data' do
          subject
          hours[0] = { hour: 0, count: 4 }
          hours[1] = { hour: 1, count: 2 }
          hours[23] = { hour: 23, count: 1 }
          expect(json_response[:data][2]).to eq(day: 2, count: 7, hours: hours)
        end
      end
    end
  end

  describe 'patron' do
    login_user(type: 'Patron')

    subject { get :index }

    describe 'GET #index' do

      it 'return error' do
        subject
        expect(response.status).to eq 403
      end

      it 'return error message' do
        subject
        expect(json_response[:errors]).to eq 'You are not authorized to access this action.'
      end
    end
  end
end
