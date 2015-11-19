require 'minitest/autorun'
require 'json'

class ApiAdapterTest < MiniTest::Test
  def self.run_api_tests
    include Tests
  end

  def setup
    @thing = Thing.new(1, 'A Thing')
  end

  module Tests
    def test_api_thing_has_slug
      assert_equal 'a-thing', @thing.slug
    end

    def test_api_thing_has_path_in_json
      assert_equal 'a-thing', JSON.parse(@thing.to_json)['path']
    end

    def test_kind_of_thing
      assert_kind_of Thing, @thing
    end
  end
end

