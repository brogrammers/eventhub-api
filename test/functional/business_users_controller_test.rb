require 'test_helper'

class BusinessUsersControllerTest < ActionController::TestCase
  setup do
    @business_member = business_members(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:business_users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create business_member" do
    assert_difference('BusinessMember.count') do
      post :create, business_member: {  }
    end

    assert_redirected_to business_member_path(assigns(:business_member))
  end

  test "should show business_member" do
    get :show, id: @business_member
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @business_member
    assert_response :success
  end

  test "should update business_member" do
    put :update, id: @business_member, business_member: {  }
    assert_redirected_to business_member_path(assigns(:business_member))
  end

  test "should destroy business_member" do
    assert_difference('BusinessMember.count', -1) do
      delete :destroy, id: @business_member
    end

    assert_redirected_to business_members_path
  end
end
