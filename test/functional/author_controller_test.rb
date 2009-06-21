# This software is licensed under GPL v2 or later. See doc/LICENSE for details.
require 'test_helper'

class AuthorControllerTest < ActionController::TestCase
  test "get login" do
    get :login
    assert_template 'login'
    assert(@response.has_template_object?('author'))
    assert_response :success
  end
  
  test "don't allow login with wrong password" do
    post :do_login, :id => 1, :author => {:email => 'test', :password => 'test'} # bad
    assert_redirected_to '/login'
  end
  
  test "allow login with right password" do
    post :do_login, :author => {:email => 'garrett@pinchzoom.com', :password => 'test'}
    assert_redirected_to '/admin'
  end
  
  # test "redirect to right page after login"do
  #   session['came_from'] = '/admin/posts' # alternative redirect
  #   post :do_login, :author => {:email => 'garrett@pinchzoom.com', :password => 'test'}
  #   assert_redirected_to '/admin/posts'
  # end
  
  test "logout works" do
    get :logout
    assert_redirected_to '/'
  end
  
end