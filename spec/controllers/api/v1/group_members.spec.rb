require 'spec_helper'

describe Api::V1::GroupMembersController do

  render_views
  fixtures :users, :core_users
  owner_id = 1

  let(:token) { stub :accessible? => true, :resource_owner_id => owner_id }

  before :each do

    class ApplicationController
      def current_user=(user)
        @current_user = user
      end

      def current_user
        @current_user
      end
    end

    request.accept = 'application/json'
    controller.stub(:doorkeeper_token) { token }
  end

end