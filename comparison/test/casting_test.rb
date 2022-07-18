require 'casting'

require_relative 'test_helper'

require_relative '../models/thing'
require_relative '../models/casting_api_adapter'

# inheriting because casting is intended to be included in the base model but
# all tests use the same model class
class CastingThing < Thing
  include Casting::Client
  delegate_missing_methods
end

class TestRefiningApiAdapterInheritance < ApiAdapterTest

  def setup
    @thing = CastingThing.new(1, 'A Thing')
    @thing.cast_as(CastingApiAdapter)
  end

  def thing_as_json
    @thing.cast(:as_json, CastingApiAdapter)
  end

  def thing_to_json
    @thing.cast(:to_json, CastingApiAdapter)
  end

  run_api_tests
end
