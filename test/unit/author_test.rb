# This software is licensed under GPL v2 or later. See doc/LICENSE for details.
require 'test_helper'

class AuthorTest < ActiveSupport::TestCase
  test "can authorize an author" do
    assert_equal authors(:garrett), Author.authorize('garrett@pinchzoom.com', 'test', true, true)
  end
  
  test "can't create without name" do
    author = Author.new
    assert !author.save
  end
  
  test "can't create without email" do
    author = Author.new
    author.name = 'test'
    assert !author.save
  end
  
  test "can't create without password" do
    author = Author.new
    author.name = 'test'
    author.email = 'test@test.com'
    assert !author.save
  end
  
  test "can create" do
    author = Author.new
    author.name = 'test'
    author.email = 'test@teset.com'
    author.password = 'test'
    assert author.save
  end
  
  test "emails must be unique" do
    author = Author.new
    author.name = 'Some Guy'
    author.email = authors(:garrett).email
    author.password = 'test'
    assert !author.save # TODO should be more specific
  end
  
  test "can change password" do
    author = authors(:garrett)
    old_pass = author.hashed_pass
    author.password = 'different'
    assert author.save
    assert old_pass != author.hashed_pass
  end
  
  test "hashed_pass is same across saves" do
    # don't get the point of this test
    author = authors(:garrett)
    old_pass = author.hashed_pass
    author.save
    author = authors(:garrett)
    new_pass = author.hashed_pass
    assert_equal old_pass, new_pass
  end
  
  test "password hash is correct" do
    author = Author.new
    author.name = 'test'
    author.email = 'test@test.com'
    author.password = 'here_is_my_pass'
    assert author.save
    assert_equal '9ca450839dab074c48794e9b073a173d1ef008d3', author.hashed_pass
  end
  
  test "can destroy author" do
    assert_difference 'Author.count', -1 do
      assert authors(:simon).destroy
    end
  end
  
end
