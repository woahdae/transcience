require_relative 'test_helper'

require_relative '../models/thing'
require_relative '../models/refining_api_adapter'

class TestRefiningApiAdapterInheritance < ApiAdapterTest
  using RefiningApiAdapter
  run_api_tests
end
