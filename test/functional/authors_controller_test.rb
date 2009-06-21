# This software is licensed under GPL v2 or later. See doc/LICENSE for details.
require 'test_helper'

class Admin::AuthorsControllerTest < ActionController::TestCase
  def setup
    # let's set cookies for authentication so that we can do tests... the admin section is protected
    @request.cookies[SL_CONFIG[:USER_EMAIL_COOKIE]] = CGI::Cookie.new(SL_CONFIG[:USER_EMAIL_COOKIE], authors(:garrett).email)
    @request.cookies[SL_CONFIG[:USER_HASH_COOKIE]] = CGI::Cookie.new(SL_CONFIG[:USER_HASH_COOKIE], authors(:garrett).hashed_pass)
  end
  
  test "can get list of authors" do
    get :author_list
    assert_template 'author_list'
    assert(@response.has_template_object?('authors'))
  end
  
  test "can create new author" do
    get :author_new
    assert_template 'author_new'
    assert(@response.has_template_object?('author'))
    assert_response :success
  end
  
  test "can create an author" do
    assert_difference 'Author.count' do
      post :author_create, :author => {:name => 'test', :email => 'test@test.com', :password => 'test'}
    end
    assert_redirected_to 'admin/authors'
  end
  
  test "can edit an author" do
    get :author_edit, :id => authors(:garrett).id
    assert_response :success
    assert_template 'author_edit'
    assert assigns(:author).valid?
  end
  
  test "can update an author to be active, then inactive" do
    post :author_update, :id => authors(:simon).id, :author => {:is_active => '1'}
    assert_equal Author.all(:conditions => 'is_active = true').count, 2
    post :author_update, :id => authors(:simon).id, :author => {:is_active => '0'}
    assert_redirected_to 'admin/authors'
    assert_equal Author.all(:conditions => 'is_active = true'), [authors(:garrett)]
  end
  
  test "can't set only active author to be inactive" do
    post :author_update, :id => authors(:garrett).id, :author => {:is_active => '0'} # shouldn't able to
    assert_equal Author.all(:conditions => 'is_active = true'), [authors(:garrett)]
  end
  
  test "can destroy an (inactive) author" do
    assert_not_nil authors(:simon)
    assert_equal authors(:simon).posts.count, 2
    assert_difference 'Author.count', -1 do
      get :author_destroy, :id => authors(:simon).id
    end
    assert_redirected_to 'admin/authors'
    assert_equal Author.all.include?( authors(:simon) ), false
    assert_equal Post.all( :conditions => "author_id = #{authors(:simon).id}" ), [] # all posts should be destroyed too...?
  end
  
  test "can't destroy only active author" do
    assert_no_difference 'Author.count' do
      get :author_destroy, :id => authors(:garrett).id
    end
    assert_redirected_to 'admin/authors'
  end
  
end






