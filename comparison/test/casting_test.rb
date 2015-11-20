require 'casting'

require_relative 'test_helper'

require_relative '../models/thing'
require_relative '../models/casting_api_adapter'

class Thing
  include Casting::Client
  include Casting::MissingMethodClient
end

class TestRefiningApiAdapterInheritance < ApiAdapterTest

  def setup
    @thing = Thing.new(1, 'A Thing')
    @thing.extend(Casting::Client)
    @thing.extend(Casting::MissingMethodClient) # not in docs, but necessary?
    @thing.cast_as(CastingApiAdapter)
  end

  run_api_tests
end
