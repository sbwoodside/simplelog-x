# This software is licensed under GPL v2 or later. See doc/LICENSE for details.
require 'test_helper'

class PostControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_template 'index'
    assert_not_nil assigns :tags
    assert_not_nil assigns :posts
  end
  
  test "should get index with single post" do
    get :index, :link => "normal"
    assert_response :success
    assert_not_nil assigns :comment
  end
  
  test "should get missing for non-existent post" do
    get :index, :link => "not_a_real_post_link"
    assert_raise( StandardError ) { assert_nil posts :not_a_real_post_link }
    assert_response :missing
  end
  
  test "should get missing for inactive post" do
    get :index, :link => "inactive"
    assert_not_nil posts :not_active
    assert_response :missing
  end
  
  test "should get an author" do
    get :authors, :id => authors(:simon).id
    assert_response :success
    assert_template 'index'
    assert_not_nil assigns :tags
    assert_not_nil assigns :posts
  end
  
  test "should get author missing" do
    get :authors, :id => 12092 # doesn't exist
    assert_response :missing
  end
  
  test "should get by day" do
    get :by_day, :year => 1867, :month => 7, :day => 1
    assert_response :success
    assert_template 'index'
    assert_not_nil assigns :posts
    assert_equal assigns(:posts), [posts(:canada_day)]
  end
  
  test "should get feed" do
    get :feed
    assert_response :success
    assert_template 'feed'
    assert_not_nil assigns(:posts)
    # TODO: how do you test results from XML Builder?
  end
  
  def test_search
    # TODO make this work when search is restored
    # you can only run this if you run the post_controller_test.rb file directly,
    # there's a bug in rails 1.0 that doesn't respect your table type in the schema
    # when raking, and we need myISAM to be in effect to run this test.
    #
    # uncomment this test if you want to run it directly    
    #post :search, :q => 'test'
    #assert assigns(:posts).length > 0
    #assert_response :success
    #post :search, :q => 'qwerty'
    #assert_equal 0, assigns(:posts).length
    #assert_response :success
  end

end


