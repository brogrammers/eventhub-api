module Api
  module V1
    class BaseController < ApplicationController
      before_filter :save_user_location, :if => lambda { request.env['user.location'] }

      resource_description do
        api_version 'v1'
        app_info 'Eventhub-Api v1 is the first API documentation by the Eventhub team. Find out how to use our System.' +
                   'Getting Started'
        api_base_url '/api/v1'
      end

      def save_user_location
        @current_user.location.latitude = request.env['user.location'][:latitude]
        @current_user.location.longitude = request.env['user.location'][:longitude]
        @current_user.save! #TODO: We should think of a global place to save the current user. We dont want to invoke .save! too much!
      end

    end
  end
end