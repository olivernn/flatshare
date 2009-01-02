require File.dirname(__FILE__) + '/../test_helper'
require 'flatshare_controller'

# Re-raise errors caught by the controller.
class FlatshareController; def rescue_action(e) raise e end; end

class FlatshareControllerTest < Test::Unit::TestCase
  fixtures :flatshares

  def setup
    @controller = FlatshareController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = flatshares(:first).id
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'list'
  end

  def test_list
    get :list

    assert_response :success
    assert_template 'list'

    assert_not_nil assigns(:flatshares)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:flatshare)
    assert assigns(:flatshare).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:flatshare)
  end

  def test_create
    num_flatshares = Flatshare.count

    post :create, :flatshare => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_flatshares + 1, Flatshare.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:flatshare)
    assert assigns(:flatshare).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Flatshare.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Flatshare.find(@first_id)
    }
  end
end
