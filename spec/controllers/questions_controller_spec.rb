require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  login_user(type: 'Patron')
  let(:question_fields) { %i[id text answer] }

  describe 'GET #index' do
    let!(:questions) { create_list(:question, 3) }
    subject { get :index }

    it 'responds successfully' do
      subject
      expect(response).to be_successful
    end

    it 'should return all records' do
      subject
      expect(json_response[:resources].size).to eq(Question.count)
    end

    it 'each object has right fields' do
      subject
      expect(json_response[:resources]).to all include *question_fields
    end
  end

  describe 'GET #index with answers' do
    let!(:answers) { create_list(:answer, 3, patron_id: @user.id, answer_value: 'answer') }
    subject { get :index }

    it 'each object has right fields' do
      subject
      json_response[:resources].each do |question|
        expect(question[:answer][:answer_value]).to eq 'answer'
        expect(question[:answer][:id]).to be
      end
    end
  end
end

