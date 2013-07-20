module Api
  module V1
    class GroupMessagesController < BaseController
      doorkeeper_for :index, :show, :create
      before_filter :can_user_access_group?
      before_filter :message_create_params, only: [:create]

      def index
        @messages = Group.find(params[:group_id]).chatroom.messages
      end

      def show
        @message = Group.find(params[:group_id]).chatroom.messages.find params[:id]
      end

      def create
        @message = Message.new :content => params[:content]
        @message.user = @current_user
        @message.chatroom = Group.find(params[:group_id]).chatroom
        @message.save!
      end

      private

      def message_create_params
        params.require :content
      end

      def can_user_access_group?
        @group = Group.find params[:group_id]
        raise ActiveRecord::RecordNotFound unless @group.can_be_seen_by? @current_user
      end

    end
  end
end