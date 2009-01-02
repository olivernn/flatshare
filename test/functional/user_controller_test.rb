require File.dirname(__FILE__) + '/../test_helper'
require 'user_controller'

# Re-raise errors caught by the controller.
class UserController; def rescue_action(e) raise e end; end

class UserControllerTest < Test::Unit::TestCase
  fixtures :users, :adverts, :messages
  def setup
    @controller = UserController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @me = users(:oliver)
    @kt = users(:kaite)
    @my_advert = adverts(:olivers_advert)
    @kt_advert = adverts(:katies_advert)
  end

  def test_succesful_login
    post :login, {:email => @me.email, :password => "computer"}
    assert_not_nil session[:user_id]
    assert_equal session[:user_id], @me.id
    assert_equal flash[:notice], "Hello #{@me.full_name}"
    assert_redirected_to :controller => 'user', :action => 'index'
  end
  
  def test_unsuccesful_login
    post :login, {:email => @me.email, :password => "wrong password"}
    assert_nil session[:user_id]
    assert_equal flash[:notice], "Invalid user/password combination"
  end
  
  def test_logout
    get :logout, nil, {:user_id => @me.id}
    assert_nil session[:user_id]
    assert_equal flash[:notice], "Goodbye"
    assert_redirected_to :controller => 'pages', :action => 'welcome'
  end
  
  def test_add_user
    post :add_user, {:user => {:first_name => "James", :second_name => "Pond", :email => "james@mail.com", :password => "password", :password_confirmation => "password", :contact_number => "07811140700"}}
    #assert_response :success
    assert_redirected_to :controller => 'payments', :action => 'index'
    assert_not_nil session[:user_id]
    assert_not_equal session[:user_id], @me.id
    assert_not_equal session[:user_id], @kt.id
    assert User.find_by_email("james@mail.com")
    assert_equal User.find_by_email("james@mail.com").id, session[:user_id]
  end
  
  def test_change_password_sucessful
    get :change_password, {:user => {:current_password => "computer", :password => "password", :password_confirmation => "password"}}, {:user_id => @me.id}
    assert_redirected_to :controller => 'user', :action => 'index'
    assert_equal session[:user_id], @me.id
    assert_equal flash[:notice], "Password changed successfully"
  end
  
  def test_change_password_unsucessful
    get :change_password, {:user => {:current_password => "password", :password => "computer", :password_confirmation => "computer"}}, {:user_id => @me.id}
    assert_redirected_to :controller => 'user', :action => 'edit_password'
    assert_equal session[:user_id], @me.id
    assert_equal flash[:notice], "Password incorrect" 
  end
  
  def test_update_user
    post :update_user, {:user => {:first_name => "rooney", :second_name => "mcjimbob"}}, {:user_id => @me.id}
    assert_redirected_to :controller => 'user', :action => 'index'
    assert_equal session[:user_id], @me.id
    assert_equal flash[:notice], "Profile updated"
    updated_user = User.find(@me.id)
    assert_equal updated_user.first_name, "rooney"
    assert_equal updated_user.second_name, "mcjimbob"
    assert_equal updated_user.email, @me.email
  end
end
