# This software is licensed under GPL v2 or later. See doc/LICENSE for details.
require 'test_helper'

class UpdateTest < ActiveSupport::TestCase
  def test_check_updates
    u = Update.find(1)
    assert_equal false, u.update_available
  end
end