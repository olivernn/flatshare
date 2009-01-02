require File.dirname(__FILE__) + '/../test_helper'
require 'help_texts_controller'

# Re-raise errors caught by the controller.
class HelpTextsController; def rescue_action(e) raise e end; end

class HelpTextsControllerTest < Test::Unit::TestCase
  fixtures :help_texts

  def setup
    @controller = HelpTextsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = help_texts(:first).id
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

    assert_not_nil assigns(:help_texts)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:help_text)
    assert assigns(:help_text).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:help_text)
  end

  def test_create
    num_help_texts = HelpText.count

    post :create, :help_text => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_help_texts + 1, HelpText.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:help_text)
    assert assigns(:help_text).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      HelpText.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      HelpText.find(@first_id)
    }
  end
end
