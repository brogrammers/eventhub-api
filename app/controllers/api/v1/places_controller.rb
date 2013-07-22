module Api
  module V1
    class PlacesController < BaseController

      doorkeeper_for :index, :create, :update, :show, :destroy
      before_filter :place_create_params, only: :create
      before_filter :place_index_params, only: :index
      before_filter :place_update_params, only: :update

      #TODO: Once we have a decent method to see if a user can see a private place
      #before_filter :can_user_see_place?, only: [:show, :update, :destroy]
      before_filter :can_user_modify_place?, only: [:update, :destroy]

      api :GET, '/places', 'Finds places'
      description 'Fetches all the places within specified latitude, longitude and offset.'
      formats [:json, :xml]
      param :latitude, Float, 'latitude', :required => true
      param :longitude, Float, 'longitude', :required => true
      param :offset, Integer, 'offset', :required => true
      example File.read("#{Rails.root}/public/docs/api/v1/places/index.json")
      example File.read("#{Rails.root}/public/docs/api/v1/places/index.xml")
      def index
        @places = Place.all_within(params[:latitude], params[:longitude], params[:offset])
      end

      api :GET, '/places/:id', 'Finds a place'
      description 'Fetches a place by id.'
      formats [:json, :xml]
      param :id, Integer, 'id', :required => true
      example File.read("#{Rails.root}/public/docs/api/v1/places/show.json")
      example File.read("#{Rails.root}/public/docs/api/v1/places/show.xml")
      def show
        @place = Place.find params[:id]
      end

      api :POST, '/places', 'Creates a Place'
      description 'Creates a Place Object. Note that you can only create a Place with visibility_type=business only with an access token with scope business.'
      formats [:json, :xml]
      param :name, String, 'name of the place', :required => true
      param :description, String, 'description of the place', :required => true
      param :visibility_type, [ 'public', 'private', 'certified' ], 'type of the place', :required => true
      param :latitude, Float, 'latitude of the place', :required => true
      param :longitude, Float, 'longitude of the place', :required => true
      example File.read("#{Rails.root}/public/docs/api/v1/places/create.json")
      example File.read("#{Rails.root}/public/docs/api/v1/places/create.xml")
      def create
        create_place
        render :action => 'create', :status => 201
      end

      api :PUT, '/places', 'Updates a Place'
      description 'Updates a Place Object. Note that you can only update a Place with visibility_type=business only with an access token with scope business.'
      formats [:json, :xml]
      param :name, String, 'name of the place'
      param :description, String, 'description of the place'
      param :visibility_type, [ 'public', 'private', 'certified' ], 'type of the place'
      param :latitude, Float, 'latitude of the place'
      param :longitude, Float, 'longitude of the place'
      example File.read("#{Rails.root}/public/docs/api/v1/places/update.json")
      example File.read("#{Rails.root}/public/docs/api/v1/places/update.xml")
      def update
        @place.name = params[:name] || @place.name
        @place.description = params[:description] || @place.description
        @place.visibility_type = params[:visibility_type] || @place.visibility_type
        @place.save!
      end

      api :DELETE, '/places/:id', 'Destroys a Place'
      description 'Deletes a Place Object given that the currently logged in user is the creator of the Place.'
      formats [:json, :xml]
      param :id, Integer, 'id of the place'
      example File.read("#{Rails.root}/public/docs/api/v1/places/update.json")
      example File.read("#{Rails.root}/public/docs/api/v1/places/update.xml")
      def destroy
        @place.destroy
      end

      private

      def can_user_see_place?
        @place = Place.find params[:id]
        raise ActiveRecord::RecordNotFound unless @place.can_be_seen_by? @current_user
      end

      def can_user_modify_place?
        @place = Place.find params[:id]
        raise ActiveRecord::NotPrivilegedError unless @place.can_be_modified_by? @current_user
      end

      def create_place
        @place = Place.new :name => params[:name], :description => params[:description], :visibility_type => params[:visibility_type]
        @place.location = created_location
        @current_user.places << @place
        @place.save!
      end

      def created_location
        @location = Location.new :latitude => params[:latitude], :longitude => params[:longitude]
        @location.save!
        @location
      end

      def place_index_params
        params.require :latitude
        params.require :longitude
        params.require :offset
      end

      def place_create_params
        params.require :name
        params.require :description
        params.require :visibility_type
        params.require :latitude
        params.require :longitude
      end

      def place_update_params
        params.permit :name, :description, :visibility_type
      end

    end
  end
end