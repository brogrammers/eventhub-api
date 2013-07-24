module Api
  module V1
    class MeController < BaseController

      resource_description do
        name 'Me'
        short_description 'Everything about the currently logged-in user'
        path '/me'
        description 'All around the currently logged-in user. Use this resource to interact with the currently logged-in users profile.'
      end

      doorkeeper_for :index

      api :GET, '/me', 'Profile of the currently logged-in user'
      description 'Fetches the profile of the currently logged-in user, based on the OAuth Access Token provided'
      formats [:json, :xml]
      example File.read("#{Rails.root}/public/docs/api/v1/me/index.json")
      example File.read("#{Rails.root}/public/docs/api/v1/me/index.xml")
      def index
        respond_with @current_user
      end

    end
  end
end