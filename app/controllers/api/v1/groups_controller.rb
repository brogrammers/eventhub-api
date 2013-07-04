module Api
  module V1
    class GroupsController < BaseController

      def index
        @groups = Group.all
      end

      def create
        @group = Group.new :name => params[:name], :description => params[:description]
        @group.chatroom = Chatroom.new
        @current_user.groups_created << group
        @group.save!
        @group.chatroom.save!
      end

      def update
        @group = Group.find params[:id]
        raise ActiveRecord::RecordNotFound unless @group.can_be_modified_by? @current_user
        @group.name = params[:name] unless params[:name].nil?
        @group.description = params[:description] unless params[:description].nil?
        @group.save!
      end

      def show
        @group = Group.find params[:id]
        raise ActiveRecord::RecordNotFound unless @group.can_be_seen_by? @current_user
        @group
      end

      def destroy
        @group = Group.find params[:id]
        raise ActiveRecord::RecordNotFound unless @group.can_be_modified_by? @current_user
        @group.destroy
      end
    end
  end
end