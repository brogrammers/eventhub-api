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
      context 'where group does not exit' do
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
          before(:all) do
            controller.current_user = create(:user)
            get :index, :group_id => group.id
          end

          it 'does not find the group' do
            assigns(:group).should be_nil
          end

          it 'does not find invited' do
            assigns(:group).should be_nil
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

  context 'GET show' do
    context 'with valid attribues' do
      3.times do |index|
        before(:each) do
          users = [group.creator, group.members[0], group.invited[0]]
          controller.current_user = users[index]
          get :show, :group => :group.id, :id => group.invited[1]
        end

        context "when current user is #{ %w(creator member invited)[index] }"
          it 'finds the right group' do
            assigns(:group).should eq group
          end

          it 'finds the right invited' do
            assigns(:member).should eq group.invited[1]
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
            users = [group.creator, group.member[0], group.invited[0], create(:user)]
            controller.current_user = users[index]
            get :show, :group_id => -1, :id => group.invited[1]
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
            users = [group.creator, group.member[0], group.invited[0]]
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
        before(:all) do
          controller.current_user = user(:create)
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

  context 'POST create' do

    context 'with valid attributes' do

    end

    context 'with invalid attributes' do

    end

  end

  context 'DELETE destroy' do

    context 'with invalid attributes' do

    end

    context 'with invalid attributes' do

    end

  end
end
