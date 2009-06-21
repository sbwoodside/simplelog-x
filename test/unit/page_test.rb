# This software is licensed under GPL v2 or later. See doc/LICENSE for details.
require 'test_helper'

class PageTest < ActiveSupport::TestCase
  def test_no_dups
    p = Page.new(:permalink => 'yo', :title => 'yo', :body_raw => 'okay')
    assert p.save
    p = Page.new(:permalink => 'yo', :title => 'yo', :body_raw => 'okay')
    assert !p.save
  end
  
  def test_create
    p = Page.new(:permalink => 'yo')
    assert !p.save
    p = Page.new(:permalink => 'yo', :title => 'yo', :body_raw => 'okay')
    assert p.save
  end
  
  def test_reserved_words
    p = Page.new(:permalink => 'show', :title => 'yo', :body_raw => 'okay')
    assert !p.save
  end
  
end