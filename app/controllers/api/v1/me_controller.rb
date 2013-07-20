module Api
  module V1
    class MeController < BaseController

      doorkeeper_for :index

      def index
        @current_user
      end

    end
  end
end