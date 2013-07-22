require 'spec_helper'

describe Api::V1::PlacesController do
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
  let(:token) { stub :accessible? => true, :resource_owner_id => owner_id }

  before :each do
    controller.stub(:doorkeeper_token) { token }
    request.accept = 'application/json'
  end

  describe 'GET #index' do

    it 'should respond successfully with a HTTP 200 status code' do
      get :index, :latitude => 55.111111, :longitude => 5.111111, :offset => 1
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it 'should render the index template' do
      get :index, :latitude => 55.111111, :longitude => 5.111111, :offset => 1
      expect(response).to render_template('index')
    end

    it 'should respond with an array of places' do
      get :index, :latitude => 53.344103999999990000, :longitude => -6.267493699999932000, :offset => 1
      body = JSON.parse(response.body) rescue { }
      expect(body['places']).to be_an(Array)
      expect(body['places'].size).to be(Place.all_within(53.344103999999990000, -6.267493699999932000, 1).size)
    end

    it 'should load all of the found places into @places' do
      get :index, :latitude => 53.344103999999990000, :longitude => -6.267493699999932000, :offset => 1
      expect(assigns(:places)).to match_array(Place.all_within(53.344103999999990000, -6.267493699999932000, 1))
    end

    context 'with missing parameters' do

      it 'should respond with a HTTP 400 status code' do
        get :index
        expect(response.status).to eq(400)
      end

    end

    context 'with private places' do

      #TODO: Once we have a decent method to see if a user can see a private place

    end

  end

  describe 'GET #show' do

    it 'should respond successfully with a HTTP 200 status code' do
      get :show, :id => Place.all.first.id
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it 'should render the show template' do
      get :show, :id => Place.all.first.id
      expect(response).to render_template('show')
    end

    it 'should respond with the desired place object' do
      get :show, :id => Place.all.first.id
      body = JSON.parse(response.body) rescue { }
      expect(body['place']).to be_a(Hash)
      expect(body['place']['id']).to eq(Place.all.first.id)
    end

    it 'should load the desired place into @place' do
      get :show, :id => Place.all.first.id
      expect(assigns(:place)).to eq(Place.all.first)
    end

    context 'a private place the current user cannot see' do

      it 'should respond with a HTTP 404 status code' do
        #TODO: Once we have a decent method to see if a user can see a private place
      end

    end

  end

  describe 'POST #create' do

    Geocoder.configure(:lookup => :test)

    Geocoder::Lookup::Test.set_default_stub(
      [
        {
          'latitude'     => 55.555555,
          'longitude'    => 55.555555,
          'city'         => 'some_city',
          'country'      => 'some_country'
        }
      ]
    )

    it 'should respond successfully with a HTTP 201 status code' do
      create_a_place
      expect(response).to be_success
      expect(response.status).to be(201)
    end

    it 'should create a new place object' do
      expect { create_a_place }.to change { Place.all.size }.by(1)
    end

    it 'should render the create template' do
      create_a_place
      expect(response).to render_template('create')
    end

    it 'should response with the created place object' do
      create_a_place
      body = JSON.parse(response.body) rescue { }
      expect(body['place']).to be_a(Hash)
      expect(body['place']['name']).to eq('test place')
      expect(body['place']['description']).to eq('description')
      expect(body['place']['visibility_type']).to eq('public')
    end

    it 'should load the desired place into @place' do
      create_a_place
      body = JSON.parse(response.body) rescue { }
      expect(assigns(:place)).to eq(Place.find body['place']['id'])
    end

    describe 'with missing parameters' do

      it 'should respond with a HTTP 400 status code' do
        post :create
        expect(response.status).to be(400)
      end

    end

  end

  describe 'PUT #update' do

    it 'should respond successfully with a HTTP 200 status code' do
      update_a_place :id => Place.all.first.id
      expect(response).to be_success
      expect(response.status).to be(200)
    end

    it 'should update a place object' do
      id = Place.all.first.id
      update_a_place :id => id, :name => 'updated name', :description => 'updated description', :visibility_type => 'private'
      updated_place = Place.find id
      expect(updated_place.name).to eq('updated name')
      expect(updated_place.description).to eq('updated description')
      expect(updated_place.visibility_type).to eq(:private)
    end

    it 'should render the update template' do
      update_a_place :id => Place.all.first.id
      expect(response).to render_template('update')
    end

    it 'should not update a place without any parameters' do
      place = Place.all.first
      update_a_place :id => place.id
      expect(place).to eq(Place.find(place.id))
    end

    context 'with invalid parameters' do

      it 'should respond with a HTTP 400 status code' do
        update_a_place :id => Place.all.first.id, :visibility_type => 'invalid'
        expect(response.status).to eq(400)
      end

    end

    context 'a place the current user cannot modify' do

      it 'should respond with a 403 HTTP status code' do
        update_a_place :id => 4
        expect(response.status).to eq(403)
      end

    end

  end

  describe 'DELETE #destroy' do

    it 'should respond successfully with a HTTP 200 status code' do
      delete :destroy, :id => 1
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it 'should load the desired place into @place' do
      place = Place.find 1
      delete :destroy, :id => 1
      expect(assigns(:place)).to eq(place)
    end

    it 'should render the destroy template' do
      delete :destroy, :id => 1
      expect(response).to render_template('destroy')
    end

    it 'should destroy a place object' do
      delete :destroy, :id => 1
      expect { Place.find 1 }.to raise_error(ActiveRecord::RecordNotFound)
    end

    context 'without creator' do

      it 'should respond with a 403 HTTP status code' do
        delete :destroy, :id => 4
        expect(response.status).to eq(403)
      end

    end

  end

end