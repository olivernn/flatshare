require File.dirname(__FILE__) + '/../test_helper'
require 'flatseekers_controller'

# Re-raise errors caught by the controller.
class FlatseekersController; def rescue_action(e) raise e end; end

class FlatseekersControllerTest < Test::Unit::TestCase
  fixtures :flatseekers

  def setup
    @controller = FlatseekersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = flatseekers(:first).id
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

    assert_not_nil assigns(:flatseekers)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:flatseeker)
    assert assigns(:flatseeker).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:flatseeker)
  end

  def test_create
    num_flatseekers = Flatseeker.count

    post :create, :flatseeker => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_flatseekers + 1, Flatseeker.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:flatseeker)
    assert assigns(:flatseeker).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Flatseeker.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Flatseeker.find(@first_id)
    }
  end
end
