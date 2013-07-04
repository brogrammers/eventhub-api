module Api
  module V1
    class MeController < BaseController

      def index
        @current_user
      end

    end
  end
end