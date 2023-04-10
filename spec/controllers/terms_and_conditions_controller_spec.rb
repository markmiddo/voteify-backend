require 'rails_helper'

RSpec.describe TermsAndConditionsController, type: :controller do
  login_user(type: 'Patron')
  let(:terms_fields) { %i[title body] }

  describe 'GET #terms_and_conditions' do
    let!(:terms_and_conditions) { create :terms_and_condition }
    subject { get :index }

    it 'responds successfully' do
      subject
      expect(response).to be_successful
    end

    it 'should return right record' do
      subject
      expect(json_response[:resource].stringify_keys).to eq(TermsAndCondition.first.slice(:title, :body).as_json)
    end
  end

end

