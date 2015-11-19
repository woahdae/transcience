require_relative 'testing_helper'

require_relative 'thing'
require_relative 'refining_api_adapter'

class TestRefiningApiAdapterInline < MiniTest::Test
  using RefiningApiAdapter

  def setup
    @thing = Thing.new(1, 'A Thing')
  end

  def test_api_thing_has_slug
    assert_equal 'a-thing', @thing.slug
  end

  def test_api_thing_has_path_in_json
    assert_equal 'a-thing', @thing.as_json[:path]
  end

  def test_kind_of_thing
    assert_kind_of Thing, @thing
  end
end
