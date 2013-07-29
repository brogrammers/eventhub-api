module Api
  module V1
    class GroupMembersController < BaseController

      doorkeeper_for :index, :show, :create, :destroy
      before_filter :can_user_access_group?

      def index
        @group = Group.find params[:group_id]
        @members = @group.members
        respond_with @members
      end

      def show
        @group = Group.find params[:group_id]
        @member = @group.members.find params[:id]
        respond_with @member
      end

      def create
        @group = Group.find params[:group_id]
        @member = @group.accept_invitation @current_user
        respond_with @member
      end

      def destroy
        @group = Group.find params[:group_id]
        @member = @group.members.find params[:id]
        @group.remove_member @member, @current_user
        respond_with @member
      end

      def can_user_access_group?
        group = Group.find params[:group_id]
        raise ActiveRecord::RecordNotFound unless group.can_be_seen_by? @current_user
      end
    end
  end
end