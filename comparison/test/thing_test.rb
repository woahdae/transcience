require_relative '../models/thing'
require 'minitest/autorun'

class TestThing < MiniTest::Test
  def setup
    @thing = Thing.new(1, 'A Thing')
  end

  def test_internal_as_json_has_no_path
    assert_equal nil, @thing.as_json[:path]
  end
end
