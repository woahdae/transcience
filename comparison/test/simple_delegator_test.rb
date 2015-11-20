require_relative 'test_helper'

require_relative '../models/thing'
require_relative '../models/simple_delegator_api_adapter'

class TestSimpleDelegatorApiAdapter < ApiAdapterTest
  def setup
    @thing = SimpleDelegatorApiAdapter.new(Thing.new(1, 'A Thing'))
  end

  run_api_tests
end
