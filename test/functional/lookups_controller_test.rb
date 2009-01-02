require File.dirname(__FILE__) + '/../test_helper'
require 'lookups_controller'

# Re-raise errors caught by the controller.
class LookupsController; def rescue_action(e) raise e end; end

class LookupsControllerTest < Test::Unit::TestCase
  fixtures :lookups

  def setup
    @controller = LookupsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = lookups(:first).id
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

    assert_not_nil assigns(:lookups)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:lookup)
    assert assigns(:lookup).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:lookup)
  end

  def test_create
    num_lookups = Lookup.count

    post :create, :lookup => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_lookups + 1, Lookup.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:lookup)
    assert assigns(:lookup).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Lookup.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Lookup.find(@first_id)
    }
  end
end
