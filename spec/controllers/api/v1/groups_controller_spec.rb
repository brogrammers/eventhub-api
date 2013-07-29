require 'spec_helper'

describe Api::V1::GroupsController do

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
    context 'with valid attributes' do
      it 'should return all groups' do
        groups = [create(:group), create(:group), create(:group)]
        get :index
        assigns(:groups).should include(groups[0], groups[1], groups[2])
      end

      it 'should return 200' do
        get :index
        response.response_code.should == 200
      end

      it 'should render index template' do
        get :index
        response.should render_template(:index)
      end
    end
  end

  describe 'POST create' do
    context 'with valid attributes' do
      it 'should create new group' do
        expect{post :create, :name => 'name2', :description => 'descrip'}.to change{Group.all.size}.by 1
      end

      it 'should render create template' do
        post :create, :name => 'name2', :description => 'descrip'
        response.should render_template(:create)
      end

      it 'should make the caller\'s groups count increase by one' do
        user = create(:user)
        controller.current_user = user
        expect{ ( post :create, :name => 'name2', :description => 'descrip') }.to change{user.reload.groups_created.size}.by(1)
      end

      it 'should return status 200' do
        post :create, :name => 'name2', :description => 'descrip'
        response.response_code.should == 200
      end

    end

    context 'with invalid attributes' do
      it 'should not create new group if attributes if name and description are missing' do
        expect{ post :create }.to_not change{Group.all.count}.by(1)
      end

      it 'should not create new group if name is missing' do
        expect{ post :create, :description => 'group description' }.to_not change{Group.all.count}.by(1)
      end

      it 'should not create a new group if description is missing' do
        expect{ post :create, :name => 'group name'}.to_not change{Group.all.count}.by(1)
      end

      it 'should not render create template' do
        post :create
        response.should_not render_template(:create)
      end

      it 'should return 400' do
        post :create
        response.response_code.should == 400
      end

      it 'should render record invalid template' do
        post :create
        response.should render_template(:record_invalid)
      end

    end
  end

  describe 'PUT update' do
    context 'with valid attributes' do
      it 'should update the specified group' do
        group = create(:group)
        controller.current_user = group.creator
        put :update, :id => group.id, :name => 'new name', :description => 'new description'
        group = Group.find group.id
        group.name.should == 'new name'
        group.description.should == 'new description'
      end

      it 'should render update template' do
        group = create(:group)
        controller.current_user = group.creator
        put :update, :id => group.id, :name => 'new name', :description => 'description'
        response.should render_template(:update)
      end

      it 'should return 200' do
        group = create(:group)
        controller.current_user = group.creator
        put :update, :id => group.id, :name => 'new name', :description => 'description'
        response.response_code.should == 200
      end

    end

    context 'with invalid attributes' do
      it 'should 404 if user shouldn\'t see the group' do
        group = create(:group)
        controller.current_user = create(:user)
        put :update, :id => group.id, :name => 'new name', :description => 'description'
        response.response_code.should == 404
      end

      it 'should return 400 found if user shouldn\'t be able to modify the group' do
        group = create(:group)
        user = create(:user)
        group.members << user
        controller.current_user = user
        put :update, :id => group.id, :name => 'new name', :description => 'description'
        response.response_code.should == 400
      end

      it 'should return 404 if group with id specified does not exist' do
        put :update, :id => 1
        response.response_code.should == 404
      end

      it 'should throw parameters invalid if parameters do not match criteria' do
        group = create(:group)
        controller.current_user = group.creator
        put :update, :id => group.id, :name => 'a', :description => 'desc'
        response.response_code.should == 400
      end
    end
  end

  describe 'GET show' do
    context 'with valid attributes' do
      it 'should return group with specified id if current user is member' do
        group = create(:group)
        user = create(:user)
        group.members << user
        controller.current_user = user
        get :show, :id => group.id
        assigns(:group).should == group
      end

      it 'should return group with specified id if current user is invited' do
        group = create(:group)
        user = create(:user)
        group.invited << user
        controller.current_user = user
        get :show, :id => group.id
        assigns(:group).should == group
      end

      it 'should return group with specified id if current user is creator' do
        group = create(:group)
        user = create(:user)
        controller.current_user = group.creator
        get :show, :id => group.id
        assigns(:group).should == group
      end

      it 'should render show template' do
        group = create(:group)
        controller.current_user = group.creator
        get :show, :id => group.id, :format => :json
        response.should render_template(:show)
      end

      it 'should return 200 to the caller' do
        group = create(:group)
        controller.current_user = group.creator
        get :show, :id => group.id, :format => :json
        response.response_code.should == 200
      end
    end

    context 'with invalid attributes' do

      it 'should return 404 if group id does not exist' do
        get :show, :id => '9999'
        response.response_code.should == 404
      end

      it 'should return 404 if group should not be seen by the user' do
        group = create(:group)
        controller.current_user = create(:user)
        get :show, :id => group.id
        response.response_code == 404
      end

      it 'should not render show template' do
        get :show, :id => '9999'
        response.should_not render_template(:show)
      end

      it 'should render not_found in case of 404' do
        get :show, :id => '9999'
        response.should render_template(:record_not_found)
      end
    end
  end

  describe 'DELETE destroy' do
    context 'with valid attributes' do
      it 'should delete group with specified attribute' do
        group = create(:group)
        controller.current_user = group.creator
        delete :destroy, :id => group.id, :format => :json
      end

      it 'should render delete temaplate' do
        group = create(:group)
        controller.current_user = group.creator
        delete :destroy, :id => group.id, :format => :json
        response.should render_template(:destroy)
      end

      it 'should return 200' do
        group = create(:group)
        controller.current_user = group.creator
        delete :destroy, :id => group.id, :format => :json
        response.response_code.should == 200
      end
    end

    context 'with invalid attributes' do
      it 'should not allow member to delete group' do
        group = create(:group)
        user = create(:user)
        group.members << user
        controller.current_user = user
        expect{delete :destroy, :id => group.id}.to_not change{Group.all.size}
      end

      it 'should not allow invited to delete group' do
        group = create(:group)
        user = create(:user)
        group.invited << user
        controller.current_user = user
        expect{ delete :destroy, :id => group.id }.to_not change{Group.all.size}
      end

      it 'should not allow not related user to delete group' do
        group = create(:group)
        user = create(:user)
        controller.current_user = user
        expect{ delete :destroy, :id => group.id }.to_not change{Group.all.size}
      end

      it 'should return 404 if group should not be seen by the user' do
        group = create(:group)
        controller.current_user = create(:user)
        delete :destroy, :id => group.id
        response.response_code.should == 404
      end

      it 'shoult return 400 if group cannot be deleted by the user' do
        group = create(:group)
        user = create(:user)
        group.invited << user
        controller.current_user = user
        delete :destroy, :id => group.id
        response.response_code.should == 400
      end

      it 'should return 404 if group does not exist' do
        delete :destroy, :id => -1
        response.response_code.should == 404
      end

      it 'should not render delete template' do
        group = create(:group)
        user = create(:user)
        controller.current_user = user
        response.should_not render_template(:destroy)
      end

      it 'should render not found template in case of 404' do
        delete :destroy, :id => -1
        response.should render_template(:record_not_found)
      end

      it 'shoult render record invalid in case of 400' do
        group = create(:group)
        user = create(:user)
        group.invited << user
        controller.current_user = user
        delete :destroy, :id => group.id
        response.should render_template(:record_invalid)
      end
    end
  end
end