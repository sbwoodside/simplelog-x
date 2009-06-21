# This software is licensed under GPL v2 or later. See doc/LICENSE for details.
require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  test "kill_tags method works" do
    str = Comment.kill_tags('<this>is<great>')
    assert_equal('is', str)
  end
  
  test "can't create comment without post" do
    c = Comment.new(:body => 'test')
    assert !c.save
  end
  
  test "can't create comment with malformed email" do
    c = Comment.new(:body_raw => 'test', :post_id => '1', :email => 'ttt')
    assert !c.save
  end
  
  test "can create comment" do
    c = Comment.new(:body_raw => 'test', :post_id => '1', :email => 'ttt@ttt.com')
    assert c.save
  end
  
  test "Blacklist works" do
    Blacklist.new(:item => 'ttt@ttt.com').save
    c = Comment.new(:body_raw => 'test', :post_id => '1', :email => 'ttt@ttt.com')
    assert !c.save
    Blacklist.delete_all
    c = Comment.new(:body_raw => 'test', :post_id => '1', :email => 'ttt@ttt.com')
    assert c.save
    Blacklist.new(:item => 'tt[0-9]+').save
    c = Comment.new(:body_raw => 'tt', :post_id => '1', :email => 'ttt@ttt.com')
    assert c.save
    c = Comment.new(:body_raw => 'tt8', :post_id => '1', :email => 'ttt@ttt.com')
    assert !c.save
  end
  
end