module Api
  module V1
    class BaseController < ApplicationController

      resource_description do
        api_version 'v1'
        app_info 'Eventhub-Api v1 is the first API documentation by the Eventhub team. Find out how to use our System.' +
          'Getting Started'
        api_base_url '/api/v1'
      end

    end
  end
end