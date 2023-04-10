require 'rails_helper'

RSpec.describe AboutUsDetailsController, type: :controller do
  login_user(type: 'Patron')
  let(:about_us_fields) { %i[id subtitle body] }

  describe 'GET #about_us' do
    let!(:about_us_details) { create_list(:about_us_detail, 3) }
    subject { get :index }

    it 'responds successfully' do
      subject
      expect(response).to be_successful
    end

    it 'should return all records' do
      subject
      expect(json_response[:resources].size).to eq(AboutUsDetail.count)
    end

    it 'each object has right fields' do
      subject
      expect(json_response[:resources]).to all include *about_us_fields
    end
  end

end

