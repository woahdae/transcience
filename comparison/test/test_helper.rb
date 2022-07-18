require 'minitest/autorun'

class ApiAdapterTest < MiniTest::Test
  def self.run_api_tests
    include Tests
  end

  def setup
    @thing = Thing.new(1, 'A Thing')
  end

  def thing_as_json
    @thing.as_json
  end

  def thing_to_json
    @thing.to_json
  end

  module Tests
    # adding a new method
    def test_api_thing_has_slug
      assert_equal 'a-thing', @thing.slug
    end

    # modifying an existing method
    def test_api_thing_has_path_in_as_json
      assert_equal 'a-thing', thing_as_json[:path]
    end

    # local rebinding
    def test_api_thing_has_path_in_to_json
      assert_equal 'a-thing', JSON.parse(thing_to_json)['path']
    end

    # maintaining some sort of class identity
    def test_kind_of_thing
      assert_kind_of Thing, @thing
    end
  end
end

