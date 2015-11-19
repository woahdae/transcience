require_relative 'testing_helper'

require_relative 'thing'
require_relative 'forwarding_api_adapter'

class TestForwardingApiAdapter < ApiAdapterTest
  def setup
    @thing = ForwardingApiAdapter.new(Thing.new(1, 'A Thing'))
  end

  run_api_tests
end
