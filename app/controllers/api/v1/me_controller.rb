module Api
  module V1
    class MeController < BaseController

      doorkeeper_for :index

      def index
        raise ActiveRecord::RecordNotFound
        @current_user
      end

    end
  end
end