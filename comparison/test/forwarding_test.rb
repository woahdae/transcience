require_relative 'test_helper'

require_relative '../models/thing'
require_relative '../models/forwarding_api_adapter'

class TestForwardingApiAdapter < ApiAdapterTest
  def setup
    @thing = ForwardingApiAdapter.new(Thing.new(1, 'A Thing'))
  end

  run_api_tests
end
