require 'test_helper'

class BrandsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:brands)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_brand
    assert_difference('Brand.count') do
      post :create, :brand => { }
    end

    assert_redirected_to brand_path(assigns(:brand))
  end

  def test_should_show_brand
    get :show, :id => brands(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => brands(:one).id
    assert_response :success
  end

  def test_should_update_brand
    put :update, :id => brands(:one).id, :brand => { }
    assert_redirected_to brand_path(assigns(:brand))
  end

  def test_should_destroy_brand
    assert_difference('Brand.count', -1) do
      delete :destroy, :id => brands(:one).id
    end

    assert_redirected_to brands_path
  end
end
