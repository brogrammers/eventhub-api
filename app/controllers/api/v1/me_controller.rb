module Api
  module V1
    class MeController < BaseController

      doorkeeper_for :index

      api :GET, '/me', 'Profile of the currently logged in user'
      description 'Fetches the profile of the currently logged in user, based on the OAuth Access Token provided'
      formats [:json, :xml]
      example File.read("#{Rails.root}/public/docs/api/v1/me/index.json")
      example File.read("#{Rails.root}/public/docs/api/v1/me/index.xml")
      def index
        respond_with @current_user
      end

    end
  end
end