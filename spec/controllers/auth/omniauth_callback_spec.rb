# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Auth::OmniauthCallbacksController, type: :controller do

  OmniAuth.config.test_mode = true

  let(:hash_from_provider) do
    {
        provider:    'facebook',
        uid:         '1234567',
        info:        {
            email:      'joe@bloggs.com',
            name:       'Joe Bloggs',
            first_name: 'Joe',
            last_name:  'Bloggs',
            image:      'https://randomuser.me/api/portraits/women/1.jpg',
            verified:   true,
            urls:       {
                Facebook: 'http://www.facebook.com/jbloggs'
            }
        },
        credentials: {
            token:      'ABCDEF...',
            expires_at: 1321747205,
            expires:    true
        }
    }.deep_stringify_keys
  end
  before(:each) do
    request.session = {
        'dta.omniauth.auth' => hash_from_provider
    }
  end

  describe 'request to success action' do
    subject { post :omniauth_success, params: {
          resource_class: 'User',
          provider:       'facebook'
      }
    }

    it 'new user created' do
      expect { subject }.to change(User, :count).by 1
    end

    it 'new user has right name' do
      subject
      expect(User.first.name).to eq(hash_from_provider['info']['name'])
    end

    it 'new user has right email' do
      subject
      expect(User.first.email).to eq(hash_from_provider['info']['email'])
    end

    it 'new user has right fb url' do
      subject
      expect(User.first.fb_url).to eq(hash_from_provider['info']['urls']['Facebook'])
    end

    it 'new user has avatar' do
      subject
      expect(User.first.avatar).to be
    end

    after(:all) do
      FileUtils.rm_rf('public/uploads/test/.')
      FileUtils.rm_rf('public/uploads/tmp/.')
    end
  end

  describe 'request to failure action' do
    subject do
      post :omniauth_failure, params: {
          resource_class: 'User',
          provider:       'facebook'
      }
    end

    it 'new user not created' do
      expect { subject }.to change(User, :count).by 0
    end
  end
end
