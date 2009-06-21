# This software is licensed under GPL v2 or later. See doc/LICENSE for details.
require 'test_helper'

class Admin::PostsControllerTest < ActionController::TestCase
  def setup
    # let's set cookies for authentication so that we can do tests... the admin section is protected
    @request.cookies[SL_CONFIG[:USER_EMAIL_COOKIE]] = CGI::Cookie.new(SL_CONFIG[:USER_EMAIL_COOKIE], authors(:garrett).email)
    @request.cookies[SL_CONFIG[:USER_HASH_COOKIE]] = CGI::Cookie.new(SL_CONFIG[:USER_HASH_COOKIE], authors(:garrett).hashed_pass)
  end
  
  def test_post_list
    get :post_list
    assert_template 'post_list'
    assert(@response.has_template_object?('posts'))
  end
  
  def test_post_new
    get :post_new
    assert_template 'post_new'
    assert(@response.has_template_object?('post'))
    assert_response :success
  end
  
  test "can create a post" do
    assert_difference 'Post.count' do
      post :post_create, :post => {:author_id => authors(:garrett), :title => 'test post', :body_raw => 'test content'}
    end
    assert_redirected_to '/admin/posts'
  end
  
  def test_post_edit
    get :post_edit, :id => posts(:normal).id
    assert_response :success
    assert_template 'post_edit'
    assert assigns(:post).valid?
  end
  
  def test_post_update
    post :post_update, :id => posts(:normal).id
    assert_redirected_to '/admin/posts'
  end
  
  test "can destroy a post" do
    assert_difference 'Post.count', -1 do
      get :post_destroy, :id => posts(:normal).id
    end
    assert_redirected_to '/admin/posts'
  end
  
end





