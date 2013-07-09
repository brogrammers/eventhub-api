module Api
  module V1
    class GroupMembersController < BaseController

      doorkeeper_for :index, :show, :destroy
      before_filter :can_user_access_group?, :only => [:index, :show, :destroy, :update]

      def index
        group = Group.find params[:group_id]
        raise ActiveRecord::RecordNotFound unless group.can_be_seen_by? @current_user
        @members = group.members
      end

      def show
        group = Group.find params[:group_id]
        raise ActiveRecord::RecordNotFound unless group.can_be_seen_by? @current_user
        @member = group.members.find members_params[:id]
      end

      def destroy
        group = Group.find params[:group_id]
        raise ActiveRecord::RecordNotFound unless group.can_be_seen_by? @current_user
        group.members.delete @current_user
      end

      def can_user_access_group?
        @group = Group.find params[:id]
        ActiveRecord::RecordNotFound  unless @group.can_be_seen_by? @current_user
      end

      def members_params
        params.permit(:user_id)
      end

    end
  end
end