require File.dirname(__FILE__) + '/../test_helper'
require 'admin/tags_controller'

# TODO need tests for searching tags, because it's broken

# Re-raise errors caught by the controller.
class Admin::TagsController; def rescue_action(e) raise e end; end

class TagsControllerTest < Test::Unit::TestCase
  
  fixtures :authors, :posts, :pages, :tags, :taggings
  
  def setup
    @controller = Admin::TagsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    # let's set cookies for authentication so that we can do tests... the admin section is protected
    @request.cookies[SL_CONFIG[:USER_EMAIL_COOKIE]] = CGI::Cookie.new(SL_CONFIG[:USER_EMAIL_COOKIE], authors(:garrett).email)
    @request.cookies[SL_CONFIG[:USER_HASH_COOKIE]] = CGI::Cookie.new(SL_CONFIG[:USER_HASH_COOKIE], authors(:garrett).hashed_pass)
  end
  
  def test_tag_list
    get :tag_list
    assert_template 'tag_list'
    assert(@response.has_template_object?('tags'))
  end
  
  def test_tag_new
    get :tag_new
    assert_template 'tag_new'
    assert(@response.has_template_object?('tag'))
    assert_response :success
  end
  
  def test_tag_create
    c = Tag.count
    post :tag_create, :tag => {:name => 'testtag'}
    assert_redirected_to '/admin/tags'
    assert_equal c+1, Tag.count
  end
  
  def test_tag_edit
    get :tag_edit, :id => 2
    assert_template 'tag_edit'
    assert(@response.has_template_object?('tag'))
    assert(assigns('tag').valid?)
    assert_response :success
  end
  
  def test_tag_update
    c = Tag.count
    post :tag_update, :id => 1, :old_name => "imperial", :tag => {:name => "imperial"}
    assert_valid Tag.find_by_name "imperial"
    assert_equal c, Tag.count
    post :tag_update, :id => 1, :old_name => "imperial", :tag => {:name => "changed"}
    assert_valid Tag.find_by_name "changed"
    assert_nil Tag.find_by_name "imperial"
    assert_equal c, Tag.count
    assert_redirected_to "/admin/tags"
  end
  
  def test_tag_update_merge
    c = Tag.count
    post :tag_create, :tag => {:name => "collision"}
    assert_equal c+1, Tag.count
    post :tag_update, :id => 2, :old_name => "imperial", :tag => {:name => "collision"}
    assert_equal c, Tag.count
  end
  
  def test_tag_destroy
    assert_not_nil Tag.find(1)
    get :tag_destroy, :id => 1
    assert_redirected_to '/admin/tags'
    assert_raise(ActiveRecord::RecordNotFound) { t = Tag.find(1) }
  end
  
end
