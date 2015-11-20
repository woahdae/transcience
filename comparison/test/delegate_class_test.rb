require_relative 'test_helper'

require_relative '../models/thing'
require_relative '../models/delegate_class_api_adapter'

class TestDelegateClassApiAdapter < ApiAdapterTest
  def setup
    @thing = DelegateClassApiAdapter.new(Thing.new(1, 'A Thing'))
  end

  run_api_tests
end
