module Api
  module V1
    class GroupMembersController < BaseController

      doorkeeper_for :index, :show, :destroy
      before_filter :can_user_access_group?

      def index
        @group = Group.find params[:group_id]
        @members = @group.members
      end

      def show
        @group = Group.find params[:group_id]
        @member = @group.members.find params[:id]
      end

      def create

      end

      def destroy
        @group = Group.find params[:group_id]
        @group.members.delete @current_user
      end

      def can_user_access_group?
        group = Group.find params[:group_id]
        raise ActiveRecord::RecordNotFound unless group.can_be_seen_by? @current_user
      end
    end
  end
end