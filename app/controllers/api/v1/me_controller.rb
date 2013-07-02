module Api
  module V1
    class MeController < BaseController

      def show
        @current_user
      end

    end
  end
end