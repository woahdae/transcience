require_relative 'test_helper'

require_relative '../models/thing'
require_relative '../models/refining_api_adapter'

# these fail because refinements don't do rebinding
class TestRefiningApiAdapterRebinding < MiniTest::Test
  using RefiningApiAdapter

  def setup
    @thing = Thing.new(1, 'A Thing')
  end

  include ApiAdapterTest::Tests
end
