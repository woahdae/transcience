require_relative 'testing_helper'

require_relative 'thing'
require_relative 'module_api_adapter'

class TestModuleApiAdapter < ApiAdapterTest
  def setup
    @thing = Thing.new(1, 'A Thing')
    @thing.extend(ModuleApiAdapter)
  end

  run_api_tests
end
