module Api
  module V1
    class GroupPendingMembersController < BaseController

      doorkeeper_for :index, :create, :update, :show, :destroy
      before_filter :can_user_access_group?
      before_filter :can_user_invite_user?, :only => [:create]

      def index
        @group = Group.find params[:group_id]
        @invited = @group.invited
        respond_with @invited
      end

      def show
        @group = Group.find params[:group_id]
        @invited = @group.invited.find params[:id]
        respond_with @invited
      end

      def create
        @group = Group.find params[:group_id]
        @invited = @group.invite_user (User.find params[:user_id]), @current_user
        respond_with @invited
      end

      def destroy
        @group = Group.find params[:group_id]
        @invited = User.find params[:id]
        @group.invited.delete @invited if @current_user == @invited or @current_user == @group.creator
        respond_with @invited
      end

      private

      def can_user_access_group?
        group = Group.find params[:group_id]
        raise ActiveRecord::RecordNotFound unless group.can_be_seen_by? @current_user
      end

      def can_user_invite_user?
        user = User.find params[:user_id]
        raise ActiveRecord::RecordNotFound unless @current_user.is_friend_of? user
      end

    end
  end
end

