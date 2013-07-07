require 'spec_helper'

describe Api::V1::GroupsController do

  render_views
  fixtures :users, :core_users
  owner_id = 1
  let(:token) { stub :accessible? => true, :resource_owner_id => owner_id }

  before :each do
    controller.stub(:doorkeeper_token) { token }
  end

  describe 'GET /groups' do
    context 'with valid attributes' do
      it 'should show all groups on call to index' do
        get :index, :format => :json
        response.response_code.should == 200
        response.should render_template(:index)
      end
    end
  end

  describe 'POST /groups' do
    context 'with valid attributes' do
      it 'should create new group' do
        group = Group.new
        Group.should_receive(:new).with('description' => 'descrip', 'name' => 'name2').and_return(group)
        group.should_receive(:save!)
        post :create, :name => 'name2', :description => 'descrip', :format => :json
      end

      it 'should render create template' do
        post :create, :name => 'name2', :description => 'descrip', :format => :json
        response.should render_template(:create)
      end

      it 'should make the caller\'s groups count increase by one' do
        user = User.find owner_id
        expect{ ( post :create, :name => 'name2', :description => 'descrip', :format => :json ) }.to change{user.groups_created.size}.by(1)
      end

      it 'should return status 200' do
        post :create, :name => 'name2', :description => 'descrip', :format => :json
        response.response_code.should == 200
      end

    end

    context 'with invalid attributes' do
      it 'should not create new group' do
        group = Group.new
        Group.should_receive(:new).and_return(group)
        expect{post :create}.to raise_error(ActiveRecord::RecordInvalid)
        group.new_record?.should be_true
      end

      it 'should not render create template' do
        expect{post :create}.to raise_error(ActiveRecord::RecordInvalid)
        response.should_not render_template(:create)
      end

      it 'should not make the caller\'s groups count increase by one' do
        user = User.find owner_id
        expect{ expect{post :create}.to raise_error(ActiveRecord::RecordInvalid) }.to change{user.groups_created.size}.by(0)
      end
    end
  end

  describe 'PUT /groups/:id' do
    context 'with valid attributes' do
      it 'should update the specified group' do
        group = Group.new
        group.creator = users :one
        Group.should_receive(:find).any_number_of_times.and_return(group)
        put :update, :id => 5, :name => 'new name', :description => 'description', :format => :json
        group.name.should == 'new name'
        group.description.should == 'description'
      end

      it 'should render correct template' do
        group = Group.new
        group.creator = users :one
        Group.should_receive(:find).any_number_of_times.and_return(group)
        put :update, :id => 5, :name => 'new name', :description => 'description', :format => :json
        response.should render_template(:update)
      end

      it 'should return 200 to the caller' do
        group = Group.new
        group.creator = users :one
        Group.should_receive(:find).any_number_of_times.and_return(group)
        put :update, :id => 5, :name => 'new name', :description => 'description', :format => :json
        response.response_code.should == 200
      end

    end

    context 'with invalid attributes' do
      it 'should return record not found if user shouldn\'t see the group' do
        group = Group.new
        group.creator = users :two
        Group.should_receive(:find).any_number_of_times.and_return(group)
        expect{ put :update, :id => 5, :name => 'new name', :description => 'description', :format => :json }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it 'should return record not found if user shouldn\'t be able to modify the group' do
        group = Group.new
        group.creator = users :two
        group.members << users(:one)
        Group.should_receive(:find).any_number_of_times.and_return(group)
        expect{ put :update, :id => 5, :name => 'new name', :description => 'description', :format => :json }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it 'should not render update template on error' do
        expect{ put :update, :id => 1 }.to raise_error(ActiveRecord::RecordNotFound)
        response.should_not render_template(:update)
      end

      it 'should throw record not found if group with id specified does not exist' do
        expect{ put :update, :id => 1 }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it 'should throw parameters invalid if parameters do not match criteria' do
        group = Group.new
        group.creator = users :one
        Group.should_receive(:find).any_number_of_times.and_return(group)
        expect{ put :update, :id => 1, :name => 'a', :description => 'desc'}.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  describe 'GET /groups/:id' do
    context 'with valid attributes' do
      it 'should fetch group with specified id' do
        group = Group.new
        group.creator = users :one
        Group.should_receive(:find).any_number_of_times.with('1').and_return(group)
        get :show, :id => 1, :format => :json
      end

      it 'should render show template' do
        group = Group.new
        group.creator = users :one
        Group.should_receive(:find).any_number_of_times.with('1').and_return(group)
        get :show, :id => 1, :format => :json
        response.should render_template(:show)
      end

      it 'should return 200 to the caller' do
        group = Group.new
        group.creator = users :one
        Group.should_receive(:find).any_number_of_times.with('1').and_return(group)
        get :show, :id => 1, :format => :json
        response.response_code.should == 200
      end
    end

    context 'with invalid attributes' do

      it 'should throw record not found if group id does not exsit' do
        expect{ get :show, :id => '9999'}.to raise_error(ActiveRecord::RecordNotFound)
      end

      it 'should throw record not found if group should not be seen by the user' do
        group = Group.new
        group.creator = users :two
        Group.should_receive(:find).any_number_of_times.with('1').and_return(group)
        expect { get :show, :id => 1 }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it 'should not render show template in case of error' do
        expect{ get :show, :id => '9999'}.to raise_error(ActiveRecord::RecordNotFound)
        response.should_not render_template(:show)
      end
    end
  end


  describe 'DELETE /groups/:id' do
    context 'with valid attributes' do
      it 'should delete group with specified attribute' do
        group = Group.new
        group.creator = users :one
        Group.should_receive(:find).any_number_of_times.with('1').and_return(group)
        group.should_receive(:destroy)
        delete :destroy, :id => '1', :format => :json
      end

      it 'should render delete temaplate' do
        group = Group.new
        group.creator = users :one
        Group.should_receive(:find).any_number_of_times.with('1').and_return(group)
        group.should_receive(:destroy)
        delete :destroy, :id => '1', :format => :json
        response.should render_template(:destroy)
      end

      it 'should return 200' do
        group = Group.new
        group.creator = users :one
        Group.should_receive(:find).any_number_of_times.with('1').and_return(group)
        group.should_receive(:destroy)
        delete :destroy, :id => '1', :format => :json
        response.response_code.should == 200
      end
    end

    context 'with invalid attributes' do
      it 'should return not found if group should not be seen by the user' do
        group = Group.new
        Group.should_receive(:find).any_number_of_times.with('1').and_return(group)
        group.creator = users :two
        group.should_not_receive(:destroy)
        expect{ delete :destroy, :id => 1, :format => :json }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it 'should not delete group with specified attribute' do

      end

      it 'should not render delete template' do

      end

      it 'should return not found if group was not found' do

      end

      it 'should return not found if group should not be seen by the user' do

      end

      it 'should not allow member to delete group' do

      end

    end

  end

end