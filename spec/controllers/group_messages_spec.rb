require 'spec_helper'

describe Api::V1::GroupMessagesController do

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

    controller.stub(:doorkeeper_token) { token }
  end


  context 'GET api/v1/groups/:group_id/messages' do
    context 'with valid parameters' do
      it 'returns all messages of the groups chatroom' do
        message = create(:message)
        controller.current_user = message.chatroom.group.creator
        get :index, :group_id => message.chatroom.group.id, :format => :json
        assigns(:messages).should == [message]
      end

      it 'renders correct template' do
        message = create(:message)
        controller.current_user = message.chatroom.group.creator
        get :index, :group_id => message.chatroom.group.id, :format => :json
        response.should render_template('index')
      end
    end

    context 'with invalid parameters' do
      it 'returns not found when user is not supposed to see that group' do
        group = create(:group)
        controller.current_user = create(:user)
        get :index, :group_id => group.id, :format => :json
        response.status.should == 404
      end

      it 'returns not found when group with specified id does not exist' do
        group = create(:group)
        expect get :index, :group_id => group.id - 1, :format => :json
        response.status.should == 404
      end

      it 'does not render template' do
        response.should_not render_template('index')
      end
    end
  end

  context 'GET api/v1/groups/:group_id/messages/:id' do
    context 'with valid parameters' do
       it 'returns message with specified id of the groups chatroom' do
         message = FactoryGirl.create :message
         controller.current_user = message.chatroom.group.creator
         get :show, :group_id => message.chatroom.group.id, :id => message.id, :format => :json
         assigns(:message).should == message
       end

       it 'renders correct template' do
         message = create(:message)
         get :show, :group_id => message.chatroom.group.id, :id => message.id, :format => :json
         response.should render_template('show')
       end
    end

    context 'with invalid parameters' do
      it 'returns not found when user is not supposed to see that group' do
        message = create(:message)
        controller.current_user = create(:user)
        get :show, :group_id => message.chatroom.group.id, :id => message.id, :format => :json
        response.status.should == 404
      end

      it 'returns not found when group with specified id does not exist' do
        group = create(:group)
        begin
          get :show, :group_id => 0, :id => 1, :format => :json
        rescue ActiveRecord::RecordNotFound

        end

        response.status.should == 404
      end

      it 'returns not found when message with given id does not exist' do
        group = create(:group)
        get :index, :group_id => group.id, :id => 1, :format => :json
        response.status.should == 404
      end

      it 'does not render template' do
        response.should_not render_template('show')
      end
    end
  end

  context 'POST api/v1/groups/:group_id/messages' do
    context 'with valid parameters' do
      it 'creates new message' do
        group = create(:group)
        controller.current_user = group.creator
        post :create, :group_id => group.id, :content => 'message content', :format => :json
        assigns(:message).content.should == 'message content'
      end

      it 'renders correct template' do
        group = create(:group)
        controller.current_user = group.creator
        post :create, :group_id => group.id, :content => 'message content', :format => :json
        response.should render_template('create')
      end

    end

    context 'with invalid parameters' do
      it 'returns not found when user is not supposed to see that group' do
        group = create(:group)
        controller.current_user = create(:user)
        get :index, :group_id => group.id, :id => 1, :format => :json
        response.status.should == 404
      end

      it 'returns not found when group with specified id does not exist' do
        group = create(:group)
        get :index, :group_id => group.id - 1, :id => 1, :format => :json
        response.status.should == 404
      end

      it 'returns bad request when content is not present' do
        group = create(:group)
        controller.current_user = group.creator
        get :create, :group_id => group.id, :format => :json
        response.status.should == 400
      end

      it 'returns bad request when content is empty' do
       group = create(:group)
       controller.current_user = group.creator
       get :create, :group_id => group.id, :content => '', :format => :json
       response.status.should == 400
      end

      it 'does not render template' do
        response.should_not render_template('create')
      end
    end
  end
end