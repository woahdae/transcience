require 'casting'

require_relative 'testing_helper'

require_relative 'thing'
require_relative 'casting_api_adapter'

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
