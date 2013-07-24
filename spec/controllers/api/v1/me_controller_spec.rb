require 'spec_helper'

describe Api::V1::MeController do
  render_views
  fixtures :core_users,
           :users,
           :business_users,
           :location_posts,
           :locations,
           :places,
           :events,
           :identities,
           :devices,
           :groups,
           :notifications,
           :messages,
           :devices,
           :destinations,
           :chatrooms,
           :comments

  owner_id = 1
  let(:token) { double :accessible? => true, :resource_owner_id => owner_id }

  before :each do
    controller.stub(:doorkeeper_token) { token }
    request.accept = 'application/json'
  end

  describe 'GET #index' do

    it 'should respond successfully with a HTTP 200 status code' do
      get :index
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it 'should render the index template' do
      get :index
      expect(response).to render_template('index')
    end

    it 'should return the currently logged-in users profile' do
      get :index
      body = JSON.parse(response.body) rescue { }
      expect(body['me']).to be_a(Hash)
    end

  end

  describe 'PUT #update' do

    it 'should respond successfully with a HTTP 200 status code' do
      put :update, :availability => "false"
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it 'should render the update template' do
      put :update, :availability => "false"
      expect(response).to render_template('update')
    end

    it 'should update the currently logged-in user' do
      put :update, :name => 'new name', :availability => "false"
      puts User.find(owner_id).name
      expect(User.find(owner_id).name).to eq('new name')
      expect(User.find(owner_id).availability).to eq(false)
    end

  end

end