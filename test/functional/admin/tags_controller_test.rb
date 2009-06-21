# This software is licensed under GPL v2 or later. See doc/LICENSE for details.
require 'test_helper'

class Admin::TagsControllerTest < ActionController::TestCase
  def setup
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
    assert_difference 'Tag.count' do
      post :tag_create, :tag => {:name => 'testtag'}
    end
    assert_redirected_to '/admin/tags'
  end
  
  def test_tag_edit
    get :tag_edit, :id => tags(:green).id
    assert_template 'tag_edit'
    assert(@response.has_template_object?('tag'))
    assert(assigns('tag').valid?)
    assert_response :success
  end
  
  def test_tag_update
    assert_no_difference 'Tag.count' do
      post :tag_update, :id => tags(:red).id, :old_name => "red", :tag => {:name => "fuschia"}
    end
    assert_valid Tag.find_by_name "fuschia"
    assert_no_difference 'Tag.count' do
      post :tag_update, :id => tags(:red).id, :old_name => "fuschia", :tag => {:name => "changed"}
    end
    assert_redirected_to "/admin/tags"
    assert_valid Tag.find_by_name "changed"
    assert_nil Tag.find_by_name "fuschia"
  end
  
  def test_tag_update_merge
    assert_difference 'Tag.count' do
      post :tag_create, :tag => {:name => "merge"}
    end
    assert_difference 'Tag.count', -1 do
      post :tag_update, :id => tags(:red).id, :old_name => "red", :tag => {:name => "merge"}
    end
  end
  
  def test_tag_destroy
    assert_not_nil Tag.find(tags(:red).id)
    get :tag_destroy, :id => tags(:red).id
    assert_redirected_to '/admin/tags'
    assert_raise(ActiveRecord::RecordNotFound) { t = Tag.find(tags(:red).id) }
  end
  
end



