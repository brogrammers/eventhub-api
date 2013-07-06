module Api
  module V1
    class GroupMembersController < BaseController
      def index
        group = Group.find params[:group_id]
        raise ActiveRecord::RecordNotFound unless group.can_be_seen_by? @current_user
        @members = group.members
      end

      def show
        group = Group.find params[:group_id]
        raise ActiveRecord::RecordNotFound unless group.can_be_seen_by? @current_user
        @member = group.members.find params[:id]
      end

      def create
        group = Group.find params[:group_id]
        raise ActiveRecord::RecordNotFound unless group.can_be_seen_by? @current_user
        @friend =  User.find params[:friend_id]
        raise ActiveRecord::RecordNotFound unless @friend.is_friend_of? @current_user
        group.invited << @friend
        @friend
      end

      def destroy
        group = Group.find params[:group_id]
        raise ActiveRecord::RecordNotFound unless group.can_be_seen_by? @current_user
        group.members.delete @current_user
      end
    end
  end
end