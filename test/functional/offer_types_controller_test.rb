require 'test_helper'

class OfferTypesControllerTest < ActionController::TestCase
  setup do
    @offer_type = offer_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:offer_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create offer_type" do
    assert_difference('OfferType.count') do
      post :create, offer_type: { name: @offer_type.name }
    end

    assert_redirected_to offer_type_path(assigns(:offer_type))
  end

  test "should show offer_type" do
    get :show, id: @offer_type
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @offer_type
    assert_response :success
  end

  test "should update offer_type" do
    put :update, id: @offer_type, offer_type: { name: @offer_type.name }
    assert_redirected_to offer_type_path(assigns(:offer_type))
  end

  test "should destroy offer_type" do
    assert_difference('OfferType.count', -1) do
      delete :destroy, id: @offer_type
    end

    assert_redirected_to offer_types_path
  end
end
