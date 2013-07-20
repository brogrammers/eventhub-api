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

  describe 'GET index' do
    context 'with valid parameters' do
      it 'should return group members if current user is a creator' do
        group = create(:group)
        group.members += [create(:user), create(:user), create(:user)]
        controller.current_user = group.creator
        get :index, :group_id => group.id
        assigns(:members).should match_array(group.members)
        assigns(:group).should == group
      end

      it 'should return group members if current user is a member' do
        group = create(:group)
        group.members += [create(:user), create(:user), create(:user)]
        controller.current_user = group.members[0]
        get :index, :group_id => group.id
        assigns(:members).should match_array(group.members)
        assigns(:group).should == group
      end

      it 'should return group members if current user is invited' do
        group = create(:group)
        group.members += [create(:user), create(:user), create(:user)]
        group.invited << create(:user)
        controller.current_user = group.invited[0]
        get :index, :group_id => group.id
        assigns(:members).should match_array(group.members)
        assigns(:group).should == group
      end

      it 'should return 200' do
        group = create(:group)
        group.members += [create(:user), create(:user), create(:user)]
        controller.current_user = group.creator
        get :index, :group_id => group.id
        response.response_code.should == 200
      end

      it 'should render index template' do
        group = create(:group)
        group.members += [create(:user), create(:user), create(:user)]
        controller.current_user = group.creator
        get :index, :group_id => group.id
        response.should render_template(:index)
      end
    end

    context 'with invalid parameters' do
      it 'should return 404 if user should not see a group' do
        group = create(:group)
        group.members += [create(:user), create(:user), create(:user)]
        controller.current_user = create(:user)
        get :index, :group_id => group.id
        response.response_code.should == 404
      end

      it 'should return 404 if group with specified id does not exist' do
        get :index, :group_id => -1
        response.response_code.should == 404
      end

      it 'should not render index template' do
        get :index, :group_id => -1
        response.should_not render_template(:index)
      end

      it 'should render not found template in case of 404' do
        get :index, :group_id => -1
        response.should render_template(:record_not_found)
      end
    end
  end

  describe 'GET show' do
    context 'with valid parameters' do
      it 'should return member with specified id if current user is a member' do
        group = create(:group)
        group.members += [create(:user), create(:user), create(:user)]
        controller.current_user = group.members[0]
        get :show, :group_id => group.id, :id => group.members[2].id
        assigns(:member).should == group.members[2]
        assigns(:group).should == group
      end

      it 'should return member with specified id if current user is invited' do
        group = create(:group)
        group.members += [create(:user), create(:user), create(:user)]
        group.invited << create(:user)
        controller.current_user = group.invited[0]
        get :show, :group_id => group.id, :id => group.members[2].id
        assigns(:member).should == group.members[2]
        assigns(:group).should == group
      end

      it 'shoult return member with specified id if current user is creator' do
        group = create(:group)
        group.members += [create(:user), create(:user), create(:user)]
        controller.current_user = group.creator
        get :show, :group_id => group.id, :id => group.members[2].id
        assigns(:member).should == group.members[2]
        assigns(:group).should == group
      end

      it 'should return 200' do
        group = create(:group)
        group.members += [create(:user), create(:user), create(:user)]
        controller.current_user = group.creator
        get :show, :group_id => group.id, :id => group.members[2].id
        response.response_code.should == 200
      end

      it 'should render show template' do
        group = create(:group)
        group.members += [create(:user), create(:user), create(:user)]
        controller.current_user = group.creator
        get :show, :group_id => group.id, :id => group.members[2].id
        response.should render_template(:show)
      end
    end

    context 'with invalid parameters' do

      it 'should return 404 if group does not exist' do
        get :show, :group_id => -1, :id => -1
        response.response_code.should == 404
      end

      it 'should return 404 if user is not supposed to see a group' do
        group = create(:group)
        group.members += [create(:user), create(:user), create(:user)]
        controller.current_user = create(:user)
        get :show, :group_id => group.id, :id => group.members[2].id
        response.response_code.should == 404
      end

      it 'should return 404 if member with specified id does not exist' do
        group = create(:group)
        group.members += [create(:user), create(:user), create(:user)]
        controller.current_user = create(:user)
        get :show, :group_id => group.id, :id => group.members[2].id
        response.response_code.should == 404
      end

      it 'should render not found in case of 404' do
        group = create(:group)
        group.members += [create(:user), create(:user), create(:user)]
        controller.current_user = create(:user)
        get :show, :group_id => group.id, :id => group.members[2].id
        response.should render_template(:record_not_found)
      end

      it 'should not render show' do
        group = create(:group)
        group.members += [create(:user), create(:user), create(:user)]
        controller.current_user = create(:user)
        get :show, :group_id => group.id, :id => group.members[2].id
        response.should_not render_template(:show)
      end
    end
  end

  describe 'POST create' do
    context 'with valid parameters' do

    end

    context 'with invalid parameters' do

    end
  end

  describe 'DELETE destroy' do
    context 'with valid parameters' do

    end

    context 'with invalid parameters' do

    end
  end

end