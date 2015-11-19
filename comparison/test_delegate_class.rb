require_relative 'testing_helper'

require_relative 'thing'
require_relative 'delegate_class_api_adapter'

class TestDelegateClassApiAdapter < ApiAdapterTest
  def setup
    @thing = DelegateClassApiAdapter.new(Thing.new(1, 'A Thing'))
  end

  run_api_tests
end
