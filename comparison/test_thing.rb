require_relative 'thing'
require 'minitest/autorun'

class TestThing < MiniTest::Test
  def setup
    @thing = Thing.new(1, 'A Thing')
  end

  def test_internal_json_has_real_id
    assert_equal 1, @thing.id
  end
end
