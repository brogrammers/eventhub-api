module Api
  module V1
    class GroupPendingMembersController < BaseController

      doorkeeper_for :index, :create, :update, :show, :destroy
      before_filter :can_user_access_group?, :only => [:index, :show, :create, :update, :destroy]

      def index
        Group.find params[:group_id]
      end

      def show
        group = Group.find params[:group_id]
        group.invited.find params[:id]
      end

      def create
        group = Group.find params[:group_id]
        user = User.find invite_params
        if group.invite_user! user, @current_user
           user
        else
            raise ActiveRecord::RecordInvalid
        end
      end

      def update
        group = Group.find params[:group_id]
        if acceptance_params[:accepted] == 'true'
          if group.accept_invitation @current_user
            @current_user
          else
            raise ActiveRecord::RecordNotFound
          end
        elsif acceptance_params[:accepted] == 'false'
          if group.decline_invitation @current_user
            @current_user
          else
            raise ActiveRecord::RecordNotFound
          end
        end
      end

      private

      def can_user_access_group?
        @group = Group.find params[:id]
        ActiveRecord::RecordNotFound  unless @group.can_be_seen_by? @current_user
      end

      def invite_params
        params.permit(:user_id)
      end

      def acceptance_params
        params.permit(:accepted)
      end

    end
  end
end

