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

  let(:group) {
    group = create(:group)
    group.members = create_list(:user, 3)
    group.invited << create(:user)
    group
  }

  describe 'on GET index' do
    context 'with valid arguments' do

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

          it 'finds the right members' do
            assigns(:members).should match_array group.members
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

    context 'with invalid parameters' do
      context 'where group is not found' do

        4.times do |index|
          before (:each) do
            users = [group.creator, group.members[0], group.invited[0], create(:user)]
            controller.current_user = users[index]
            get :index, :group_id => -1
          end

          context "when current user is #{ %w(creator member invited non_related)[index] }" do
            it 'does not find a group' do
              assigns(:group).should be_nil
            end

            it 'does not find members' do
              assigns(:members).should be_nil
            end

            it 'does not render index template' do
             response.should_not render_template :index
            end

            it 'renders record not found' do
              response.should render_template :record_not_found
            end

            it 'responds with 200' do
              response.status.should eq 404
            end
          end

        end

        context 'non reladed shows members' do

          before (:each) do
            controller.current_user = create(:user)
            get :index, :group_id => group.id
          end

          it 'does not find group' do
            assigns(:group).should be_nil
          end

          it 'does not find members' do
            assigns(:members).should be_nil
          end

          it 'renders record not found template' do
            response.should render_template :record_not_found
          end

          it 'responds with 200' do
            response.response_code.should eq 404
          end
        end
      end
    end
  end

  describe 'on GET show' do

    context 'with valid parameters' do

      3.times do |index|
        before :each do
          users = [group.creator, group.members[0], group.invited[0], create(:user)]
          controller.current_user = users[index]
          get :show, :group_id => group.id, :id => group.members[1]
        end

        context "when current user is #{ %w(creator member invited non_related)[index] }" do
          it 'finds the right group' do
            assigns(:group).should eq group
          end

          it 'finds the right member' do
            assigns(:member).should eq group.members[1]
          end

          it 'renders show template' do
            response.should render_template :show
          end

          it 'responds with 200' do
            response.response_code.should eq 200
          end
        end
      end
    end

    context 'with invalid parameters' do

      context 'where group does not exist' do
        4.times do |index|
          before :each do
            users = [group.creator, group.members[1], group.invited[0], create(:user)]
            controller.current_user = users[index]
            get :show, :group_id => -1, :id => group.members[0]
          end

          context "when current user is #{ %w(creator member invited non_related)[index] }" do
            it 'does not find the group' do
              assigns(:group).should be_nil
            end

            it 'it does not find the member' do
              assigns(:member).should eq nil
            end

            it 'renders record_not_found' do
              response.should render_template :record_not_found
            end

            it 'responds with 404' do
              response.response_code.should eq 404
            end
          end
        end
      end

      context 'where member does not exist' do
        4.times do |index|
          before :each do
            users = [group.creator, group.members[1], group.invited[0], create(:user)]
            controller.current_user = users[index]
            get :show, :group_id => group.id, :id => -1
          end

          context "when current user is #{ %w(creator member invited non_related)[index] }" do
            it 'finds the right group' do
              assigns(:group).should eq group
            end

            it 'does not find the member' do
              assigns(:member).should be_nil
            end

            it 'renders record not found' do
              response.should render_template :record_not_found
            end

            it 'responds with 404' do
              response.response_code.should eq 404
            end
          end
        end
      end

      context 'and shows a member' do

        before(:each) do
          controller.current_user = create(:user)
          get :show, :group_id => group.id, :id => group.members[0]
        end

        it 'does not find group' do
          assigns(:group).should be_nil
        end
        it 'does not find member' do
          assigns(:member).should be_nil
        end

        it 'renders record not found' do
          response.should render_template :record_not_found
        end

        it 'responds with 404' do
           response.response_code.should eq 404
        end
      end
    end

  end

  describe 'on POST create' do

    before(:each) do
      @members_created = 3
      @invited_created = 3
      @group = create(:group)
      @group.members = create_list(:user, @members_created)
      @group.invited = create_list(:user, @invited_created)
    end

    context 'with valid parameters' do

      context 'and curent user is invited' do

        before (:each) do
          controller.current_user = @group.invited[0]
          post :create, :group_id => @group.id
        end

        it 'finds the right group' do
          assigns(:group).should eq @group
        end

        it 'finds a right member' do
          assigns(:member).should eq @group.invited[0]
        end

        it 'responds with 200' do
          response.response_code.should eq 200
        end

        it 'renders create template' do
          response.should render_template :create
        end

        it 'adds a member' do
          @group.reload.members.size.should eq @members_created +1
        end

        it 'removes invited' do
          @group.reload.invited.size.should eq @invited_created -1
        end
      end
    end

    context 'with invalid parameters' do

      context 'where group is not found' do

        4.times do |index|
          before(:each) do
            users = [@group.creator, @group.members[0], @group.invited[0], create(:user)]
            controller.current_user = users[index]
            post :create, :group_id => -1
          end

          context "when current is #{%w(creator member invited non_related)[index]}" do
            it 'does not find the group' do
              assigns(:group).should be_nil
            end

            it 'does not find the member' do
              assigns(:member).should be_nil
            end

            it 'does not alter members' do
              @group.reload.members.size.should eq @members_created
            end

            it 'does not alter invited' do
              @group.reload.invited.size.should eq @invited_created
            end

            it 'responds with 404' do
              response.response_code.should eq 404
            end

            it 'renders not found' do
              response.should render_template :record_not_found
            end
          end
        end
      end

      context 'where invitation is not present' do
        2.times do |index|
          before(:each) do
            users = [@group.creator, @group.members[0]]
            controller.current_user = users[index]
            post :create, :group_id => @group.id
          end

          context "when current user is #{ %w(creator member)[index] }" do
            it 'finds the right group' do
              assigns(:group).should eq @group
            end

            it 'does not create member' do
              assigns(:member).should be_nil
            end

            it 'does not alter members' do
              @group.reload.members.size.should eq @members_created
            end

            it 'does not alter invited' do
              @group.reload.invited.size.should eq @invited_created
            end

            it 'it responds with 400' do
              response.response_code.should eq 400
            end

            it 'renders record invalid' do
              response.should render_template :record_invalid
            end
          end
        end
      end

      context 'where current user is not related' do

        context 'and tries to create a member' do

          before(:each) do
            controller.current_user = create(:user)
            post :create, :group_id => @group.id
          end

          it 'does not find group' do
            assigns(:group).should be_nil
          end

          it 'does not find member' do
            assigns(:member).should be_nil
          end

          it 'does not alter members' do
            @group.reload.members.size.should eq @members_created
          end

          it 'does not alter invited' do
            @group.reload.invited.size.should eq @invited_created
          end

          it 'responds with 404' do
            response.response_code.should eq 404
          end

          it 'renders record not found' do
            response.should render_template :record_not_found
          end
        end
      end
    end
  end

  describe 'on DELETE destroy' do

    context 'with valid parameters' do

      2.times do |index|
        before(:each) do
          @members_created = 3
          @group = create(:group_with_members_and_invited)
          users = [@group.creator, @group.members[0]]
          controller.current_user = users[index]
          delete :destroy, :group_id => @group.id, :id => @group.members[0].id
         end

        context "when current user is #{ %w(creator member)[index] }" do
          it 'finds the right group' do
            assigns(:group).should eq @group
          end

          it 'finds the right member' do
            assigns(:member).should eq @group.members[0]
          end

          it 'removes a member' do
            @group.members(true).size.should eq @members_created - 1
          end

          it 'responds with 200' do
            response.response_code.should eq 200
          end

          it 'renders destroy' do
             response.should render_template :destroy
          end
        end
      end
    end

    context 'with invalid parameters' do

      context 'and group is not found' do
        4.times do |index|
          before (:each) do
            @members_created = 3
            @group = create(:group_with_members_and_invited)
            user = [@group.creator, @group.members[0], @group.invited[0], create(:user)][index]
            controller.current_user = user
            delete :destroy, :group_id => -1, :id => @group.members[0].id
          end

          context "when current user is #{%w(creator, member, invited, not_related)[index]}" do
            it 'does not find group' do
              assigns(:group).should be_nil
            end

            it 'does not find member' do
              assigns(:member).should be_nil
            end

            it 'does not alter a members' do
              @group.reload.members.size.should eq @members_created
            end

            it 'responds with 404' do
              response.response_code.should eq 404
            end

            it 'renders record not found' do
              response.should render_template :record_not_found
            end
          end
        end
      end

      context 'member is not found' do
        3.times do |index|
          before (:each) do
            @members_created = 3
            @group = create(:group_with_members_and_invited)
            user = [@group.creator, @group.members[0], @group.invited[0]][index]
            controller.current_user = user
            delete :destroy, :group_id => @group.id, :id => -1
          end

          context "when current user is #{%w(creator, member, invited)[index]}" do
            it 'finds the group' do
              assigns(:group).should eq @group
            end

            it 'it does not find member' do
              assigns(:member).should be_nil
            end

            it 'does not alter group members' do
              @group.reload.members.size.should eq @members_created
            end

            it 'responds with 404' do
              response.response_code.should eq 404
            end

            it 'renders record not found' do
              response.should render_template :record_not_found
            end
          end
        end
      end

      context 'user is not allowed to delete a member' do
        2.times do |index|
          before(:each) do
            @members_created = 3
            @group = create(:group_with_members_and_invited)
            users = [@group.members[0], @group.invited[0]]
            controller.current_user = users[index]
            delete :destroy, :group_id => @group.id, :id => @group.members[1].id
          end

          context "when current user is #{%w(creator, member)[index]}" do
            it 'finds the group' do
              assigns(:group).should eq @group
            end

            it 'finds the member' do
              assigns(:member).should eq @group.members[1]
            end

            it 'does not alter members' do
              @group.members.size.should eq @members_created
            end

            it 'responds with 400' do
              response.response_code.should eq 400
            end

            it 'renders record invalid' do
              response.should render_template :record_invalid
            end
          end
        end
      end


      context 'where current user is not related' do
        context 'and deletes a member' do
          before (:each) do
            @members_created = 3
            @group = create(:group_with_members_and_invited)
            controller.current_user = create(:user)
            delete :destroy, :group_id => @group.id, :id => @group.members[0].id
          end

          it 'does not find group' do
            assigns(:group).should be_nil
          end

          it 'does not find member' do
            assigns(:member).should be_nil
          end

          it 'it does not alter members' do
            @group.members.size.should eq @members_created
          end

          it 'responds with 404' do
            response.response_code.should eq 404
          end

          it 'renders record not found' do
            response.should render_template :record_not_found
          end
        end

        context 'and member does not exist' do

          before (:each) do
            @members_created = 3
            @group = create(:group_with_members_and_invited)
            controller.current_user = create(:user)
            delete :destroy, :group_id => @group.id, :id => -1
          end

          it { assigns(:group).should be_nil }
          it { assigns(:member).should be_nil }
          it { @group.members.size.should eq @members_created }
          it { response.response_code.should eq 404 }
          it { response.should render_template(:record_not_found) }

        end
      end
    end
  end
end