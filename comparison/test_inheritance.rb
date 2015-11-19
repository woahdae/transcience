require_relative 'testing_helper'

require_relative 'thing'
require_relative 'inheriting_api_adapter'

class TestInheritingApiAdapter < ApiAdapterTest
  def setup
    @thing = InheritingApiAdapter.new(1, 'A Thing')
  end

  run_api_tests
end
