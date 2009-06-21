# This software is licensed under GPL v2 or later. See doc/LICENSE for details.
require 'test_helper'

class BlacklistTest < ActiveSupport::TestCase
  def test_add_item
    bl = Blacklist.new
    assert !bl.save
    bl.item = 'giddyup.com'
    assert bl.save
  end
  
  def test_add_to_cache
    assert_equal([], Blacklist.cache)
    Blacklist.add_to_cache(Blacklist.new(:item => 'nownownow.com'))
    assert_equal(1, Blacklist.cache.length)
  end
  
  def test_empty_cache
    assert_equal(1, Blacklist.cache.length)
    Blacklist.delete_from_cache(Blacklist.new(:item => 'nownownow.com'))
    assert_equal([], Blacklist.cache)
    Blacklist.add_to_cache(Blacklist.new(:item => '111'))
    Blacklist.add_to_cache(Blacklist.new(:item => '222'))
    assert_equal(2, Blacklist.cache.length)
    Blacklist.clear_cache
    assert_equal([], Blacklist.cache)
  end
  
end
