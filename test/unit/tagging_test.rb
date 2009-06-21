# This software is licensed under GPL v2 or later. See doc/LICENSE for details.
require 'test_helper'

class TaggingTest < ActiveSupport::TestCase
  test "post has correct tags" do
    assert posts(:normal).tags.include? tags(:red)
    assert posts(:normal).tags.include? tags(:green)
    assert !( posts(:normal).tags.include? tags(:violet) )
  end
  
  test "can add a tag" do
    tag = Tag.new :name => "fuschia"
    posts(:normal).tags << tag
    posts(:normal).tags.include? tag
  end
  
  test "can replace tags on a page using tag_with and tag_list" do
    pages(:hello).tag_with "fuschia yellow"
    assert_equal "fuschia yellow", pages(:hello).tag_list # alpha order
  end
  
  test "can find pages using tagged_with" do
    assert_equal Page.tagged_with("red"), [pages(:hello), pages(:about)]
  end
  
  test "can remove tags from post" do
    posts(:normal)._remove_tags ["red", "green"]
    assert posts(:normal).tags.empty?
  end
  
  test "tag_list method" do
    assert_equal posts(:normal).tag_list, "green red"
  end
    
  test "posts and pages are taggable" do
    assert_raises(RuntimeError) do 
      taggings(:page_about_red).send(:taggable?, true) 
    end
    assert !( taggings(:page_about_red).send(:taggable?) )
    assert pages(:about).send(:taggable?)
    assert posts(:normal).send(:taggable?)
  end
    
end
