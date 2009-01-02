require File.dirname(__FILE__) + '/../test_helper'
require 'stations_controller'

# Re-raise errors caught by the controller.
class StationsController; def rescue_action(e) raise e end; end

class StationsControllerTest < Test::Unit::TestCase
  fixtures :stations

  def setup
    @controller = StationsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = stations(:first).id
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

    assert_not_nil assigns(:stations)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:station)
    assert assigns(:station).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:station)
  end

  def test_create
    num_stations = Station.count

    post :create, :station => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_stations + 1, Station.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:station)
    assert assigns(:station).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Station.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Station.find(@first_id)
    }
  end
end
