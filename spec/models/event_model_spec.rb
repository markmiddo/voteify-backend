require 'rails_helper'
RSpec.describe Event, type: :model do

  CSV_ROW_COUNT = 3

  let(:fake_video_ids) { %w(QyxdQDaVzb0 OUWF_ZVll94) }

  before(:each) do
    allow(YouTube).to receive(:http_get).and_return YouTubeSuccess.new(video_ids: fake_video_ids)
  end

  describe 'date validations' do
    context 'with invalid start event' do
      let(:event) { build(:event, start_date: 2.days.ago) }

      it 'return false if errors in event_start_date' do
        event.valid?
        expect(event.errors[:start_date]).to eq(['Start date cannot be earlier than current date.'])
      end
    end

    context 'with invalid end_date' do
      let(:event) do
        build(:event, start_date: 1.days.from_now, end_date: 2.days.ago)
      end

      it 'should have end date validate error' do
        event.valid?
        expect(event.errors[:end_date]).to eq(['End date cannot be earlier than start date.'])
      end
    end
  end

  describe 'minimum user count for voting validating' do

    context 'greater than 10' do
      let(:event) { build(:event, track_count_for_vote: 20) }

      it 'should have validate error' do
        event.valid?
        expect(event.errors[:track_count_for_vote]).to eq(['must be less than or equal to 10'])
      end
    end

    context 'less than 1' do
      let(:event) { build(:event, track_count_for_vote: 0) }

      it 'should have validate error' do
        event.valid?
        expect(event.errors[:track_count_for_vote]).to eq(['must be greater than or equal to 1'])
      end
    end
  end

  describe 'pixel_id validation' do
    context 'invalid fb_pixel' do
      let(:invalid_fb_pixel) { 'invalid fb_pixel' }
      let(:event) { build(:event, :with_resources, fb_pixel: invalid_fb_pixel) }

      it 'should have fb_pixel validate error' do
        event.valid?
        expect(event.errors[:fb_pixel]).to eq([I18n.t('activerecord.errors.models.event.attributes.fb_pixel.format')])
      end
    end

    context 'valid fb_pixel' do
      let(:valid_fb_pixel) { '888888889999' }
      let(:event) { build(:event, :with_resources, fb_pixel: valid_fb_pixel) }

      it 'should have NOT fb_pixel validate error' do
        event.valid?
        expect(event.errors[:fb_pixel]).to be_empty
      end
    end

    context 'fb_pixel with whitespaces' do
      let(:valid_fb_pixel) { '888888889999    ' }
      let(:event) { build(:event, :with_resources, fb_pixel: valid_fb_pixel) }

      it 'should have not validation error' do
        event.valid?
        expect(event.errors[:fb_pixel]).to be_empty
      end

      it 'should trim whitespaces inside fb_pixel' do
        event.valid?
        expect(event.errors[:fb_pixel]).to be_empty
      end
    end
  end

  describe 'google_analytic validation' do
    context 'invalid google_analytic' do
      let(:invalid_google_analytic) { 'invalid google_analytic' }
      let(:event) { build(:event, :with_resources, google_analytic: invalid_google_analytic) }

      it 'should have NOT google_analytic validate error' do
        event.valid?
        expect(event.errors[:google_analytic])
            .to eq([I18n.t('activerecord.errors.models.event.attributes.google_analytic.format')])
      end
    end

    context 'valid google_analytic' do
      let(:valid_google_analytic) { 'UA-88888888-90' }
      let(:event) { build(:event, :with_resources, google_analytic: valid_google_analytic) }

      it 'should have NOT google_analytic validate error' do
        event.valid?
        expect(event.errors[:google_analytic]).to be_empty
      end
    end

    context 'google_analytic with whitespaces' do
      let(:valid_google_analytic) { 'UA-88888888-90   ' }
      let(:event) { build(:event, :with_resources, google_analytic: valid_google_analytic) }

      it 'should have NOT google_analytic validate error' do
        event.valid?
        expect(event.errors[:google_analytic]).to be_empty
      end

      it 'should strip whitespaces inside google analytic value' do
        event.valid?
        expect(event.google_analytic).to eq valid_google_analytic.strip
      end
    end
  end

  describe 'validation on colors' do
    let(:invalid_color_value) { :invalid_color }
    context 'validation on text_color property' do
      subject { build(:event, :with_resources, text_color: invalid_color_value) }

      it 'should throw ArgumentError, invalid value for text_color property' do
        expect { subject }.to raise_error(ArgumentError, "'#{invalid_color_value}' is not a valid text_color")
      end
    end
  end

  describe 'parse csv file' do

    let(:event) { create :event, :with_files  }
    subject { event }

    it 'success create' do
      expect { subject }.to change(Event, :count).by 1
    end

    it 'create event tracks' do
      expect(subject.tracks.count).to eq 2
    end

    it 'create track' do
      expect { subject }.to change(Track, :count).by 2
    end

    it 'strip whitespaces from tracks title' do
      subject

      track_titles = Track.all.pluck(:title)
      track_titles.each do |title|
        expect(title).not_to include("\n", "\r")
      end
    end

    it 'strip whitespaces from tracks author' do
      subject

      authors = Track.all.pluck(:author)
      authors.each do |author|
        expect(author).not_to include("\n", "\r")
      end
    end


    context 'whole file upload' do
      let(:fake_video_ids) { Array.new(CSV_ROW_COUNT).map.with_index {|_, index| "video#{index}" } }

      it 'save original author and title to event truck' do
        subject

        CSV.parse(File.read(event.csv_file.path)) do |(author, title)|
          event_track = EventTrack.find_by(event: event, original_author: author.strip, original_title: title.strip)
          expect(event_track).to be_present
        end
      end

      context 'when several rows already handled' do
        let(:processed_line_count) { 1 }
        let(:event) { create :event, :with_files, csv_processed_line_count: processed_line_count }

        it 'handle only new rows from document' do
          expect { subject }.to change(EventTrack, :count).by CSV_ROW_COUNT - processed_line_count
        end

        it 'change event processed line count' do
          subject
          expect(event.reload.csv_processed_line_count).to eq CSV_ROW_COUNT
        end
      end
    end

    describe 'tracks already exists' do
      let!(:track1) { create :track, author: 'TARKAN', title: 'Dudu',  video_id: '111' }
      let!(:track2) { create :track, author: 'Selfy',  title: 'Галя',  video_id: '222' }
      let!(:track3) { create :track, author: 'other',  title: 'other', video_id: 'OUWF_ZVll94' }

      it 'create event tracks' do
        expect(subject.tracks.count).to eq 2
      end

      it 'create track' do
        expect { subject }.to change(Track, :count).by 1
      end
    end
  end

  describe 'square image validation' do
    let(:rectangular_image) do
      Rack::Test::UploadedFile.new(File.join(Rails.root, '/spec/support/images/rectangular_image.jpg'))
    end

    let(:event) { build(:event, :with_resources, square_image: rectangular_image) }

    it 'should have validate error' do
      event.valid?
      expect(event.errors[:square_image]).to eq(['Image is not square'])
    end
  end
end
