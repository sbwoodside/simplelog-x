# This software is licensed under GPL v2 or later. See doc/LICENSE for details.
require 'test_helper'

class Admin::BaseControllerTest < ActionController::TestCase
  def setup
    # let's set cookies for authentication so that we can do tests... the admin section is protected
    @request.cookies[SL_CONFIG[:USER_EMAIL_COOKIE]] = CGI::Cookie.new(SL_CONFIG[:USER_EMAIL_COOKIE], authors(:garrett).email)
    @request.cookies[SL_CONFIG[:USER_HASH_COOKIE]] = CGI::Cookie.new(SL_CONFIG[:USER_HASH_COOKIE], authors(:garrett).hashed_pass)
  end
  
  def test_filter
    @request.cookies[SL_CONFIG[:USER_EMAIL_COOKIE]] = nil
    @request.cookies[SL_CONFIG[:USER_HASH_COOKIE]] = nil
    get :author_edit, :id => 1
    assert_response 302
    assert_redirected_to 'login'
  end
  
  def test_user_auth
    assert_equal false, Author.authorize('poop', 'badpass')
    assert_equal true, Author.authorize(authors(:garrett).email, authors(:garrett).hashed_pass)
  end
  
  def test_some_routes
    route = {:controller => 'admin/posts', :action => 'post_edit', :id => '1'}
    assert_routing 'admin/posts/edit/1', route
    route = {:controller => 'admin/tags', :action => 'tag_edit', :id => '1'}
    assert_routing 'admin/tags/edit/1', route
    route = {:controller => 'admin/authors', :action => 'author_update', :id => '1'}
    assert_routing 'admin/authors/update/1', route
    route = {:controller => 'admin/misc', :action => 'do_ping'}
    assert_routing 'admin/ping/do', route
    #route = {:controller => 'xmlrpc', :action => 'api'} # I disabled XML RPC server
    #assert_routing 'xmlrpc/api', route
  end
  
end
