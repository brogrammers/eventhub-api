require 'spec_helper'


#tests are divided per action per current_user possibity

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

        context "when current user is #{ %w(creator member invited non_related)[index] }" do

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

  describe 'GET show' do

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

  describe 'POST create' do

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

      context 'where current user is creator' do

        context 'and group is not found' do

          before(:each) do
            controller.current_user = @group.creator
            post :create, :group_id => -1
          end

          it { assigns(:group).should be_nil }

          it { assigns(:member).should be_nil }

          it { @group.reload.members.size.should eq @members_created }

          it { @group.reload.invited.size.should eq @invited_created }

          it { response.response_code.should eq 404 }

          it { response.should render_template :record_not_found }

        end

        context 'and tries to create a member' do

          before(:each) do
            controller.current_user = @group.creator
            post :create, :group_id => @group.id
          end

          it { assigns(:group).should eq @group }

          it { assigns(:member).should be_nil }

          it { @group.reload.members.size.should eq @members_created }

          it { @group.reload.invited.size.should eq @invited_created }

          it { response.response_code.should eq 400 }

          it { response.should render_template :record_invalid }

        end

      end

      context 'where current user is member' do

        context 'and group is not found' do

          before(:each) do
            controller.current_user = @group.members[0]
            post :create, :group_id => -1
          end

          it { assigns(:group).should be_nil }

          it { assigns(:members).should be_nil }

          it { @group.reload.members.size.should eq @members_created }

          it { @group.reload.invited.size.should eq @invited_created }

          it { response.response_code.should eq 404 }

          it { response.should render_template :record_not_found }

        end

        context 'and creates a member' do

          before(:each) do
            controller.current_user = @group.members[0]
            post :create, :group_id => @group.id
          end

          it { assigns(:group).should eq @group }

          it { assigns(:member).should be_nil }

          it { @group.reload.members.size.should eq @members_created }

          it { @group.reload.invited.size.should eq @invited_created }

          it { response.response_code.should eq 400 }

          it { response.should render_template :record_invalid }

        end

      end

      context 'where current user is invited' do

        context 'and group is not found' do

          before(:each) do
            controller.current_user = @group.invited[0]
            post :create, :group_id => -1
          end

          it { assigns(:group).should be_nil }

          it { assigns(:member).should be_nil }

          it { @group.reload.members.size.should eq @members_created }

          it { @group.reload.invited.size.should eq @invited_created }

          it { response.response_code.should eq 404 }

          it { response.should render_template :record_not_found }


        end

      end

      context 'where current user is not related' do

        context 'and group is not found' do

          before(:each) do
            controller.current_user = create(:user)
            post :create, :group_id => -1
          end

          it { assigns(:group).should be_nil }

          it { assigns(:member).should be_nil }

          it { @group.reload.members.size.should eq @members_created }

          it { @group.reload.invited.size.should eq @invited_created }

          it { response.response_code.should eq 404 }

          it { response.should render_template :record_not_found}

        end

        context 'and tries to create a member' do

          before(:each) do
            controller.current_user = create(:user)
            post :create, :group_id => @group.id
          end

          it { assigns(:group).should be_nil }

          it { assigns(:member).should be_nil }

          it { @group.reload.members.size.should eq @members_created }

          it { @group.reload.invited.size.should eq @invited_created }

          it { response.response_code.should eq 404 }

          it { response.should render_template :record_not_found }

        end

      end

    end

  end

  describe 'DELETE destroy' do

    before(:each) do
      @members_created = 3
      @group = create(:group)
      @group.members = create_list(:user, @members_created)
      @group.invited << create(:user)
    end

    context 'with valid parameters' do

      context 'where current user is creator' do

        context 'and deletes a member' do

          before(:each) do
            controller.current_user = @group.creator
            delete :destroy, :group_id => @group.id, :id => @group.members[0].id
          end

          it { assigns(:group).should eq @group }
          it { assigns(:member).should eq @group.members[0] }
          it { @group.members(true).size.should eq @members_created - 1 }
          it { response.response_code.should eq 200 }
          it { response.should render_template :destroy }

        end

      end

      context 'and current user is a member' do

          before(:each) do
            controller.current_user = @group.members[0]
            delete :destroy, :group_id => @group.id, :id => @group.members[0].id
          end

          context 'and deletes himself' do

            it { assigns(:group).should eq @group }
            it { assigns(:member).should eq @group.members[0] }
            it { response.response_code.should eq 200 }
            it { response.should render_template :destroy }
            it { @group.members.reload.size.should eq @members_created - 1 }

          end

      end

    end

    context 'with invalid parameters' do

      context 'where current user is creator' do

        context 'and group is not found' do

          before (:each) do
            controller.current_user = @group.creator
            delete :destroy, :group_id => -1, :id => @group.members[0]
          end

          it { assigns(:group).should be_nil }
          it { assigns(:member).should be_nil }
          it { @group.reload.members.size.should eq @members_created }
          it { response.response_code.should eq 404 }
          it { response.should render_template :record_not_found}

        end

        context 'and member is not found' do

          before (:each) do
            controller.current_user = @group.creator
            delete :destroy, :group_id => @group.id, :id => -1
          end

          it { assigns(:group).should eq @group }
          it { assigns(:member).should be_nil }
          it { @group.reload.members.size.should eq @members_created }
          it { response.response_code.should eq 404}
          it { response.should render_template :record_not_found }

        end

      end

      context 'where current user is member' do

        context 'and deletes other member' do

          before (:each) do
            controller.current_user = @group.members[0]
            delete :destroy, :group_id => @group.id, :id => @group.members[1]
          end

          it { assigns(:group).should eq @group }
          it { assigns(:member).should eq @group.members[1] }
          it { @group.members.size.should eq @members_created }
          it { response.response_code.should eq 400 }
          it { response.should render_template :record_invalid }

        end

        context 'and member does not exist' do

          before (:each) do
            controller.current_user = @group.members[0]
            delete :destroy, :group_id => @group.id, :id => -1
          end

          it { assigns(:group).should eq @group }
          it { assigns(:member).should be_nil }
          it { @group.reload.members.size.should eq @members_created }
          it { response.response_code.should eq 404 }
          it { response.should render_template :record_not_found }

        end

        context 'and group does not exist' do

          before (:each) do
            controller.current_user = @group.members[0]
            delete :destroy, :group_id => -1, :id => @group.members[1]
          end

          it { assigns(:group).should be_nil }
          it { assigns(:member).should be_nil }
          it { @group.reload.members.size.should eq @members_created }
          it { response.response_code.should eq 404 }
          it { response.should render_template :record_not_found }

        end

      end

      context 'where current user is invited' do

        context 'and deletes a member' do

          before (:each) do
            controller.current_user = @group.invited[0]
            delete :destroy, :group_id => @group.id, :id => @group.members[0]
          end

          it { assigns(:group).should eq @group }
          it { assigns(:member).should eq @group.members[0] }
          it { @group.members.size.should eq @members_created }
          it { response.response_code.should eq 400 }
          it { response.should render_template :record_invalid }

        end

        context 'and member does not exist' do

          before (:each) do
            controller.current_user = @group.invited[0]
            delete :destroy, :group_id => @group.id, :id => -1
          end

          it { assigns(:group).should eq @group }
          it { assigns(:member).should be_nil }
          it { @group.reload.members.size.should eq @members_created }
          it { response.status.should eq 404 }
          it { response.should render_template :record_not_found }

        end

        context 'and group does not exist' do

          before (:each) do
            controller.current_user = @group.invited[0]
            delete :destroy, :group_id => -1, :id => @group.members[0]
          end

          it { assigns(:group).should be_nil }
          it { assigns(:member).should be_nil }
          it { response.response_code.should eq 404 }
          it { response.should render_template :record_not_found }
          it { @group.members.size.should eq @members_created }

        end

      end

      context 'where current user is not related' do

        context 'and deletes a member' do

          before (:each) do
            controller.current_user = create(:user)
            delete :destroy, :group_id => @group.id, :id => @group.members[0]
          end

          it { assigns(:group).should be_nil }
          it { assigns(:member).should be_nil }
          it { @group.members.size.should eq @members_created }
          it { response.response_code.should eq 404 }
          it { response.should render_template :record_not_found }


        end

        context 'and member does not exist' do

          before (:each) do
            controller.current_user = create(:user)
            delete :destroy, :group_id => @group.id, :id => -1
          end

          it { assigns(:group).should be_nil }
          it { assigns(:member).should be_nil }
          it { @group.members.size.should eq @members_created }
          it { response.response_code.should eq 404 }
          it { response.should render_template(:record_not_found) }

        end

        context 'and group does not exist' do

          before (:each) do
            controller.current_user = create(:user)
            delete :destroy, :group_id => -1, :id => group.members[0]
          end

          it { assigns(:group).should be_nil }
          it { assigns(:member).should be_nil }
          it { @group.reload.members.size.should eq @members_created }
          it { response.response_code.should eq 404 }
          it { response.should render_template :record_not_found }

        end
      end
    end
  end
end