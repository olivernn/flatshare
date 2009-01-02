require File.dirname(__FILE__) + '/../test_helper'
require 'rich_attriubte_controller'

# Re-raise errors caught by the controller.
class RichAttriubteController; def rescue_action(e) raise e end; end

class RichAttriubteControllerTest < Test::Unit::TestCase
  fixtures :rich_attributes

  def setup
    @controller = RichAttriubteController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = rich_attributes(:first).id
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

    assert_not_nil assigns(:rich_attributes)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:rich_attribute)
    assert assigns(:rich_attribute).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:rich_attribute)
  end

  def test_create
    num_rich_attributes = RichAttribute.count

    post :create, :rich_attribute => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_rich_attributes + 1, RichAttribute.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:rich_attribute)
    assert assigns(:rich_attribute).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      RichAttribute.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      RichAttribute.find(@first_id)
    }
  end
end
