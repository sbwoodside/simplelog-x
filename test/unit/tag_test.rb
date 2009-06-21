# This software is licensed under GPL v2 or later. See doc/LICENSE for details.
require 'test_helper'

class TagTest < ActiveSupport::TestCase
  # TODO why not use fixtures???
  def test_to_s
    @obj = Page.find(:first)
    @obj.tag_with "pale imperial"
    assert_equal "imperial pale", Page.find(:first).tags.to_s
  end
end
