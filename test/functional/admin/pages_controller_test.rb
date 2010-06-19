# This software is licensed under GPL v2 or later. See doc/LICENSE for details.
require 'test_helper'

class Admin::PagesControllerTest < ActionController::TestCase
  def setup
    # let's set cookies for authentication so that we can do tests... the admin section is protected
    @request.cookies[SL_CONFIG[:USER_EMAIL_COOKIE]] = CGI::Cookie.new(SL_CONFIG[:USER_EMAIL_COOKIE], authors(:garrett).email)
    @request.cookies[SL_CONFIG[:USER_HASH_COOKIE]] = CGI::Cookie.new(SL_CONFIG[:USER_HASH_COOKIE], authors(:garrett).hashed_pass)
  end
  
  test "can list all of the pages" do
    get :page_list
    assert_template 'page_list'
    assert assigns :pages
  end

  # def test_page_edit
  #   get :page_edit, :id => 1
  #   assert_template 'page_edit'
  #   assert(@response.has_template_object?('page'))
  #   assert(assigns('page').valid?)
  #   assert_response :success
  # end

  # def test_page_update
  #   post :page_update, :id => 1, :page => {:is_active => false}
  #   assert_redirected_to 'admin/pages'
  #   assert_equal 1, Page.find(:all, :conditions => ['is_active = ?', false]).length
  #   post :page_update, :id => 1, :page => {:is_active => true}
  # end

  test "can destroy a page" do
    assert_difference 'Page.count', -1 do
      get :page_destroy, :id => pages(:hello)
    end
    assert_redirected_to '/admin/pages'
    assert_equal Page.all.include?( pages(:hello) ), false
  end
  
end