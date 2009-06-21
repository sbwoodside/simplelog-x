# This software is licensed under GPL v2 or later. See doc/LICENSE for details.
require 'test_helper'

class TagControllerTest < ActionController::TestCase
  def test_tag_archive
    get :show, :tag => tags(:red).name
    assert_response :success
    assert_template 'show'
    assert_not_nil assigns(:tags)
    assert_not_nil assigns(:posts)
    # TODO check if the actual values of :tags and :posts are right....
    get :show, :tag => 'asdfsdfsdf' # doesn't exist
    assert_response :missing
  end
  
end
