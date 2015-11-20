require_relative 'test_helper'

require_relative '../models/thing'
require_relative '../models/module_api_adapter'

class TestModuleApiAdapter < ApiAdapterTest
  def setup
    @thing = Thing.new(1, 'A Thing')
    @thing.extend(ModuleApiAdapter)
  end

  run_api_tests
end
