require_relative 'test_helper'

require_relative '../models/thing'
require_relative '../models/inheriting_api_adapter'

class TestInheritingApiAdapter < ApiAdapterTest
  def setup
    @thing = InheritingApiAdapter.new(1, 'A Thing')
  end

  run_api_tests
end
