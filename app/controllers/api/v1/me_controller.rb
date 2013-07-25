module Api
  module V1
    class MeController < BaseController

      before_filter :me_update_params, only: [:update]

      resource_description do
        name 'Me'
        short_description 'Everything about the currently logged-in user'
        path '/me'
        description 'All around the currently logged-in user. Use this resource to interact with the currently logged-in users profile.'
      end

      doorkeeper_for :index, :update

      api :GET, '/me', 'Profile of the currently logged-in user'
      description 'Fetches the profile of the currently logged-in user, based on the OAuth Access Token provided.'
      formats [:json, :xml]
      example File.read("#{Rails.root}/public/docs/api/v1/me/index.json")
      example File.read("#{Rails.root}/public/docs/api/v1/me/index.xml")
      def index
        respond_with @current_user
      end

      api :PUT, '/me', 'Updates the currently logged-in user'
      description 'Updates the profiles of the currently logged-in user, based on the OAuth Access Token provided.'
      formats [:json, :xml]
      param :availability, String, 'Availability of the user', :required => true
      def update
        @current_user.availability = params[:availability]
        @current_user.save!
        respond_with @current_user
      end

      private

      def me_update_params
        params.require(:availability)
      end
    end
  end
end