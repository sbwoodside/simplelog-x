require File.dirname(__FILE__) + '/../test_helper'
require 'tag_controller'

# Re-raise errors caught by the controller.
class TagController; def rescue_action(e) raise e end; end

class TagControllerTest < Test::Unit::TestCase
  
  fixtures :tags, :posts, :taggings
  
  def setup
    @controller = TagController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  
  def test_tag_archive
    get :show, :tag => tags(:tags_001).name
    assert_response :success
    assert_template 'show'
    assert_not_nil assigns(:tags)
    assert_not_nil assigns(:posts)
    # TODO check if the actual values of :tags and :posts are right....
    get :show, :tag => 'asdfsdfsdf' # doesn't exist
    assert_response :missing
  end
  
end
