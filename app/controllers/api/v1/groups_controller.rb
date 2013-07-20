module Api
  module V1
    class GroupsController < BaseController

      doorkeeper_for :index, :create, :update, :show, :destroy
      before_filter :can_user_access_group?, :only => [:update, :show, :destroy]
      before_filter :can_user_modify_group?, :only => [:update, :destroy]

      def index
        @groups = Group.all
      end

      def create
        @group = Group.new(group_params)
        @current_user.groups_created << @group
        @group.save!
      end

      def update
        @group = Group.find params[:id]
        @group.update_attributes!(group_params)
        @group.save!
      end

      def show
        @group = Group.find(params[:id])
        @group
      end

      def destroy
        @group = Group.find params[:id]
        @group.destroy
      end

      private

      #validations

      def can_user_access_group?
        @group = Group.find params[:id]
        raise ActiveRecord::RecordNotFound unless @group.can_be_seen_by? @current_user
      end

      def can_user_modify_group?
        @group = Group.find params[:id]
        raise unless @group.can_be_modified_by? @current_user
      end

      def group_params
        params.permit(:description, :name)
      end
    end
  end
end