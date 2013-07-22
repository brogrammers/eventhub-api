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

      def index
        @places = Place.all_within(params[:latitude], params[:longitude], params[:offset])
      end

      def show
        @place = Place.find params[:id]
      end

      def create
        create_place
        render :action => 'create', :status => 201
      end

      def update
        @place.name = params[:name] || @place.name
        @place.description = params[:description] || @place.description
        @place.visibility_type = params[:visibility_type] || @place.visibility_type
        @place.save!
      end

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