require_relative 'testing_helper'

require_relative 'thing'
require_relative 'refining_api_adapter'

class TestRefiningApiAdapterInheritance < ApiAdapterTest
  using RefiningApiAdapter
  run_api_tests
end
