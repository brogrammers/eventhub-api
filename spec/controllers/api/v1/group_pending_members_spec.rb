require 'spec_helper'

describe Api::V1::GroupPendingMembersController do

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

  context 'on GET index' do

    let(:group){
      group = create(:group_with_members_and_more_invited)
    }

    context 'with valid attributes' do
      3.times do |index|
        before(:each) do
          users = [group.creator, group.members[0], group.invited[0]]
          controller.current_user = users[index]
          get :index, :group_id => group.id
        end

        context "when current user is #{ %w(creator member invited)[index] }" do

          it 'finds the right group' do
            assigns(:group).should eq group
          end

          it 'finds the invited' do
            assigns(:invited).should match_array group.invited
          end

          it 'renders index template' do
            response.should render_template :index
          end

          it 'responds with 200' do
            response.response_code.should eq 200
          end
        end
      end
    end

    context 'with invalid attributes' do
      context 'where group does not exist' do
        4.times do |index|
          before(:each) do
            users = [group.creator, group.members[0], group.invited[0], create(:user)]
            controller.current_user = users[index]
            get :index, :group_id => -1
          end

          context "when current user is #{ %w(creator member invited not related)[index] }" do
            it 'does not find the group' do
              assigns(:group).should be_nil
            end

            it 'does not find invited' do
              assigns(:invited).should be_nil
            end

            it 'renders record not found template' do
              response.should render_template :record_not_found
            end

            it 'responds with 404' do
              response.response_code.should eq 404
            end
          end
        end

        context 'current user is not related' do
          before(:each) do
            controller.current_user = create(:user)
            get :index, :group_id => group.id
          end

          it 'does not find the group' do
            assigns(:group).should be_nil
          end

          it 'does not find invited' do
            assigns(:invited).should be_nil
          end

          it 'renders record not found template' do
            response.should render_template :record_not_found
          end

          it 'responds with 404' do
            response.response_code.should eq 404
          end
        end
     end
  end

  end

  context 'on GET show' do

    let(:group){
      group = create(:group_with_members_and_more_invited)
    }

    context 'with valid attribues' do
      3.times do |index|
        before(:each) do
          users = [group.creator, group.members[0], group.invited[0]]
          controller.current_user = users[index]
          get :show, :group_id => group.id, :id => group.invited[1].id
        end

        context "when current user is #{ %w(creator member invited)[index] }"
          it 'finds the right group' do
            assigns(:group).should eq group
          end

          it 'finds the right invited' do
            assigns(:invited).should eq group.invited[1]
          end

          it 'renders show template' do
            response.should render_template :show
          end

          it 'responds with 200' do
            response.response_code.should eq 200
          end
      end
    end

    context 'with invalid attributes' do
      context 'where group does not exist' do
        4.times do |index|
          before(:each) do
            users = [group.creator, group.members[0], group.invited[0], create(:user)]
            controller.current_user = users[index]
            get :show, :group_id => -1, :id => group.invited[1].id
          end

          context " when current user is #{ %w(creator member invited not_related)[index]} " do
            it 'does not find group' do
              assigns(:group).should be_nil
            end

            it 'does not find member' do
              assigns(:member).should be_nil
            end

            it 'renders record not found template' do
              response.should render_template :record_not_found
            end

            it 'responds with 404' do
              response.response_code.should eq 404
            end
          end
        end
      end

      context 'where invited does not exist' do
        3.times do |index|
          before(:each) do
            users = [group.creator, group.members[0], group.invited[0]]
            controller.current_user = users[index]
            get :show, :group_id => group.id, :id => -1
          end

          context "when current user is #{ %w(creator member invited)[index] }" do
            it 'finds the right group' do
              assigns(:group).should eq group
            end

            it 'does not find invited' do
              assigns(:invited).should be_nil
            end

            it 'renders record not found template' do
              response.should render_template :record_not_found
            end

            it 'responds with 404' do
              response.response_code.should eq 404
            end
          end
        end
      end

      context 'where unrelated user shows invited' do
        before(:each) do
          controller.current_user = create(:user)
          get :show, :group_id => group.id, :id => group.invited[0]
        end

        it 'does not find the group' do
          assigns(:group).should be_nil
        end

        it 'does not find invited' do
          assigns(:invited).should be_nil
        end

        it 'renders record not found template' do
          response.should render_template :record_not_found
        end

        it 'reponds with 404' do
          response.response_code.should eq 404
        end
      end
    end
  end

  context 'on POST create' do
    context 'with valid attributes' do
      2.times do |index|
        before(:each) do
          @group = create(:group_with_members_and_more_invited)
          @invited_created = 3
          @user_to_invite = create(:user)
          controller.current_user = [@group.creator, @group.members[0]][index]
          controller.current_user.friends << @user_to_invite
          post :create, :group_id => @group.id, :user_id => @user_to_invite.id
        end

        context "when current user is #{ %w(creator member)[index] }" do
          it 'finds the right group' do
            assigns(:group).should eq @group
          end

          it 'creates an invited' do
            assigns(:invited).should eq @user_to_invite
          end

          it 'adds user to invited' do
            @group.reload.invited.size.should eq @invited_created + 1
          end

          it 'adds group to users invitations' do
            @user_to_invite.reload.groups_invited_to.should match_array [@group]
          end

          it 'responds with 200' do
            response.response_code.should eq 200
          end

          it 'renders create template' do
            response.should render_template :create
          end
        end
      end
    end

    context 'with invalid attributes' do

      describe 'group does not exist' do
        4.times do |index|
          before(:each) do
            @group = create(:group_with_members_and_more_invited)
            @user = create(:user)
            @invited_created = 3
            controller.current_user = [@group.creator, @group.members[0], @group.invited[0], create(:user)][index]
            controller.current_user.friends << @user
            post :create, :group_id => -1 , :user_id => @user.id
          end

          context "when current user is #{ %w(creator member invited non_related) }" do

            it 'does not find group' do
              assigns(:group).should be_nil
            end

            it 'does not create invited' do
              assigns(:invited).should be_nil
            end

            it 'renders not found template' do
              response.should render_template :record_not_found
            end

            it 'responds with 404' do
               response.response_code.should eq 404
            end
          end
        end
      end

      describe 'user to invite is not found' do
        4.times do |index|
          before(:each) do
            @group = create(:group_with_members_and_more_invited)
            @user = create(:user)
            @invited_created = 3
            controller.current_user = [@group.creator, @group.members[0], @group.invited[0], create(:user)][index]
            controller.current_user.friends << @user
            post :create, :group_id => @group.id , :user_id => -1
          end

          context "when current user is #{ %w(creator member invited non_relared)[index]}" do
            it 'finds the right group' do
              assigns(:group).should be_nil
            end

            it 'does not create invited' do
              assigns(:invited).should be_nil
            end

            it 'does not alter group invited' do
              @group.reload.invited.size.should eq @invited_created
            end

            it 'renders not found template' do
              response.response_code.should eq 404
            end

            it 'responds with 404' do
              response.should render_template :record_not_found
            end
           end
         end
      end

      describe 'user to invite is already invited' do
       2.times do |index|
         before(:each) do
           @group = create(:group_with_members_and_more_invited)
           @invited_created = 3
           controller.current_user = [@group.creator, @group.members[0]][index]
           controller.current_user.friends << @group.invited[0]
           post :create, :group_id => @group.id , :user_id => @group.invited[0].id
         end

          context 'when current user is %w(creator member)' do

            it 'finds the right group' do
              assigns(:group).should eq @group
            end

            it 'does not create invited' do
              assigns(:invited).should be_nil
            end

            it 'does not alter group invited' do
              @group.reload.invited.size.should eq @invited_created
            end

            it 'renders record invalid template' do
              response.should render_template :record_invalid
            end

            it 'responds with 400' do
              response.response_code.should eq 400
            end
          end
        end
      end

      describe 'user to invite is a creator' do
        2.times do |index|
          before(:each) do
            @group = create(:group_with_members_and_more_invited)
            @invited_created = 3
            controller.current_user = [@group.creator, @group.members[0]][index]
            controller.current_user.friends << @group.creator
            post :create, :group_id => @group.id , :user_id => @group.creator.id
          end

          context 'when current user is %w(creator member)' do
            it 'finds the right group' do
              assigns(:group).should eq @group
            end

            it 'does not create invited' do
              assigns(:invited).should be_nil
            end

            it 'does not alter group invited' do
              @group.reload.invited.size.should eq @invited_created
            end

            it 'renders record invalid template' do
              response.should render_template :record_invalid
            end

            it 'responds with 400' do
              response.response_code.should eq 400
            end
          end
        end
      end

      describe 'user to invite is already a member' do
        2.times do |index|
          before(:each) do
            @group = create(:group_with_members_and_more_invited)
            @invited_created = 3
            controller.current_user = [@group.creator, @group.members[0]][index]
            controller.current_user.friends << @group.members[1]
            post :create, :group_id => @group.id , :user_id => @group.members[1].id
          end

          context 'when current user is %w(creator member)' do
            it 'finds the right group' do
              assigns(:group).should eq @group
            end

            it 'does not create invited' do
              assigns(:invited).should be_nil
            end

            it 'does not alter group invited' do
              @group.reload.invited.size.should eq @invited_created
            end

            it 'renders record invalid template' do
              response.should render_template :record_invalid
            end

            it 'responds with 400' do
              response.response_code.should eq 400
            end
          end
        end
      end

      describe 'user to invite is not a friend with current user' do
        2.times do |index|
          before(:each) do
            @group = create(:group_with_members_and_more_invited)
            @user = create(:user)
            @invited_created = 3
            controller.current_user = [@group.creator, @group.members[0]][index]
            post :create, :group_id => @group.id , :user_id => @user.id
          end

          context 'when current user is %w(creator member)' do
            it 'finds the right group' do
              assigns(:group).should be_nil
            end

           it 'does not create invited' do
             assigns(:invited).should be_nil
            end

            it 'does not alter group invited' do
              @group.reload.invited.size.should eq @invited_created
           end

            it 'renders record invalid template' do
              response.should render_template :record_not_found
            end

            it 'responds with 400' do
              response.response_code.should eq 404
            end
          end
        end
      end

      describe 'current user is not related' do
        before(:each) do
          @group = create(:group_with_members_and_more_invited)
          @user_to_invite = create(:user)
          @user_inviting = create(:user)
          @invited_created = 3
          @user_inviting.friends << @user_to_invite
          controller.current_user = @user_inviting
          post :create, :group_id => @group.id , :user_id => @user_to_invite.id
        end

        it 'finds the right group' do
          assigns(:group).should be_nil
        end

        it 'does not create invited' do
          assigns(:invited).should be_nil
        end

        it 'does not alter group invited' do
          @group.reload.invited.size.should eq @invited_created
        end

        it 'renders record invalid template' do
          response.should render_template :record_not_found
        end

        it 'responds with 400' do
          response.response_code.should eq 404
        end
      end

      describe 'current user is invited' do
        before(:each) do
          @group = create(:group_with_members_and_more_invited)
          @invited_created = 3
          @user_to_invite = create(:user)
          @group.invited[0].friends << @user_to_invite
          controller.current_user = @group.invited[0]
          post :create, :group_id => @group.id , :user_id => @user_to_invite.id
        end

        it 'finds the right group' do
          assigns(:group).should eq @group
        end

        it 'does not create invited' do
          assigns(:invited).should be_nil
        end

        it 'does not alter group invited' do
          @group.reload.invited.size.should eq @invited_created
        end

        it 'renders record invalid template' do
          response.should render_template :record_invalid
        end

        it 'responds with 400' do
          response.response_code.should eq 400
        end
      end
    end
  end

  context 'on DELETE destroy' do

    context 'with valid attributes' do

      2.times do |index|
        before (:each) do
          @group = create(:group_with_members_and_more_invited)
          @invited_created = 3
          controller.current_user = [@group.creator, @group.invited[0]][index]
          delete :destroy, :group_id => @group.id, :id => @group.invited[0].id
        end

        context "when current user is #{%w(creator invited)[index]}" do

          it 'finds the right group' do
            assigns(:group).should eq @group
          end

          it 'finds the invited' do
            assigns(:invited).should eq @group.invited[0]
          end

          it 'removes invited' do
            @group.reload.invited.size.should eq @invited_created - 1
          end

          it 'renders delete template' do
            response.should render_template :destroy
          end

          it 'responds with 200' do
            response.response_code.should eq 200
          end
        end
      end
    end
  end
end
