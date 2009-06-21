# This software is licensed under GPL v2 or later. See doc/LICENSE for details.
require 'test_helper'

class Admin::CommentsControllerTest < ActionController::TestCase
  def setup
    # let's set cookies for authentication so that we can do tests... the admin section is protected
    @request.cookies[SL_CONFIG[:USER_EMAIL_COOKIE]] = CGI::Cookie.new(SL_CONFIG[:USER_EMAIL_COOKIE], authors(:garrett).email)
    @request.cookies[SL_CONFIG[:USER_HASH_COOKIE]] = CGI::Cookie.new(SL_CONFIG[:USER_HASH_COOKIE], authors(:garrett).hashed_pass)
  end
  
  test "can get list of comments" do
    get :comment_list
    assert_template 'comment_list'
    assert assigns :comments
  end
  
  test "can edit comment" do
    assert_no_difference 'Comment.count' do
      get :comment_edit, :id => comments(:strawberry_fields)
    end
    assert_response :success
    assert_template 'comment_edit'
    assert assigns( :comment ).valid?
  end
  
  test "can set a comment to be not approved" do
    assert_no_difference 'Comment.count' do
      post :comment_update, :id => comments(:strawberry_fields).id, :comment => {:is_approved => false}
    end
    assert_redirected_to 'admin/comments'
    assert_equal Comment.find( comments(:strawberry_fields).id ).is_approved, false
  end
  
  test "can destroy a comment" do
    assert_difference 'Comment.count', -1 do
      get :comment_destroy, :id => comments(:strawberry_fields).id
    end
    assert_redirected_to 'admin/comments'
    assert_raise(ActiveRecord::RecordNotFound) { Comment.find comments(:strawberry_fields).id }
  end
  
end