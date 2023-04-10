require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  login_user

  describe 'GET #show' do
    subject { get :show, params: { id: @user.id } }

    it 'responds successfully' do
      subject
      expect(response).to be_successful
    end

    describe 'user with type patron' do

      it 'return user attributes' do
        subject
        expect(json_response[:resource]).to include(:id, :name, :email, :avatar, :type)
      end
    end

    describe 'user with type patron' do
      login_user(type: 'Client')

      it 'return user attributes' do
        subject
        expect(json_response[:resource]).to include(:id, :name, :email, :avatar, :type, :company_name)
      end
    end

  end

  describe 'PUT #update' do
    let(:new_params) { { name: 'new_name' } }
    subject { put :update, params: { id: @user.id, resource: new_params } }

    it 'responds successfully' do
      subject
      expect(response).to be_successful
    end

    it 'should return new name' do
      subject
      expect(json_response[:resource][:name]).to eq('new_name')
    end

    it 'should return email validate errors' do
      new_params.merge!(email: 'email')
      subject
      expect(json_response[:errors][:email]).to eq(['is not an email'])
    end

    describe 'user avatar' do
      let(:avatar) do
        Rack::Test::UploadedFile.new(File.join(Rails.root, '/spec/support/images/test-img.jpg'))
      end

      it 'should return email validate errors' do
        subject
        expect(response).to be_successful
      end

      it 'update photo' do
        new_params.merge!(avatar: avatar)
        subject
        expect(json_response[:resource][:avatar][:url]).to_not be_empty
      end

      after(:all) do
        FileUtils.rm_rf('public/uploads/test/.')
        FileUtils.rm_rf('public/uploads/tmp/.')
      end
    end
  end

  describe 'PUT #answer on question' do
    login_user(type: 'Patron')
    let(:questions) { create_list(:question, 3) }
    let(:answers) do
      questions.map do |question|
        { question_id: question.id, answer_value: 'answer' }
      end
    end
    let(:new_params) { { answers_attributes: answers } }
    subject { put :update, params: { id: @user.id, resource: new_params } }

    it 'responds successfully' do
      subject
      expect(response).to be_successful
    end

    it 'should create answer' do
      expect { subject }.to change(Answer, :count).by questions.size
    end

    context 'answer without value' do
      let(:answers) do
        questions.map do |question|
          { question_id: question.id  }
        end
      end
    end

    describe 'change answer on question' do
      before(:each) do
        @patron =  Patron.find(@user.id)
        @patron.answers_attributes = answers
      end
      let(:new_answers) do
        @patron.reload.answers.map do |answer|
          { id: answer.id, question_id: answer.question_id, answer_value: 'new answer' }
        end
      end
      let(:new_params) { { answers_attributes: new_answers } }

      it 'should update exist answer, not create new' do
        expect { subject }.to change(Answer, :count).by 0
      end

      it 'should change answer in DB' do
        subject
        @patron.reload.answers.each do |answer|
          expect(answer.answer_value).to eq('new answer')
        end
      end
    end
  end
  describe 'PUT #update_type' do
    subject { put :update_type, params: { user_id: @user.id, resource: new_params } }

    describe 'update type to Patron' do
      let(:new_params) { { name: 'new_name', type: 'Patron' } }

      it 'should change user type to Patron' do
        subject
        expect(json_response[:resource][:type]).to eq('Patron')
      end
    end

    describe 'update type to Client' do
      let(:new_params) { { name: 'new_name', type: 'Client' } }

      it 'should change user type to Patron' do
        subject
        expect(json_response[:resource][:type]).to eq('Client')
      end
    end

    describe 'update type to Admin' do
      let(:new_params) { { name: 'new_name', type: 'Admin' } }

      it 'should change user type to Patron' do
        subject
        expect(json_response[:errors]).to eq('found unpermitted parameter: :type')
      end
    end
  end
end
