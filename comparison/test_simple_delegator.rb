require_relative 'testing_helper'

require_relative 'thing'
require_relative 'simple_delegator_api_adapter'

class TestSimpleDelegatorApiAdapter < ApiAdapterTest
  def setup
    @thing = SimpleDelegatorApiAdapter.new(Thing.new(1, 'A Thing'))
  end

  run_api_tests
end
