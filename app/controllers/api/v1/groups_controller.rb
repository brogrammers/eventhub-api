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

      end

      def show
        @group = Group.find params[:id]
        if(@current_user.can_see? @group)
            @group
        else
            raise ActiveRecord::RecordNotFound.new
        end
      end

    end
  end
end