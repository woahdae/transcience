require_relative 'models/thing'
require_relative 'models/inheriting_api_adapter'
require_relative 'models/module_api_adapter'
require_relative 'models/forwarding_api_adapter'
require_relative 'models/simple_delegator_api_adapter'
require_relative 'models/delegate_class_api_adapter'
require_relative 'models/refining_api_adapter'
require_relative 'models/casting_api_adapter'

require 'benchmark'

class Thing
  include Casting::Client
  include Casting::MissingMethodClient
end

class ExtendedThing < Thing
  include ModuleApiAdapter
end

ITERATIONS = 10000

raise if InheritingApiAdapter.new(1, 'A Thing').as_json[:path].nil?
raise if Thing.new(1, 'A Thing').tap {|t| t.extend(ModuleApiAdapter)}.as_json[:path].nil?
raise if ExtendedThing.new(1, 'A Thing').as_json[:path].nil?
raise if ForwardingApiAdapter.new(Thing.new(1, 'A Thing')).as_json[:path].nil?
raise if SimpleDelegatorApiAdapter.new(Thing.new(1, 'A Thing')).as_json[:path].nil?
raise if DelegateClassApiAdapter.new(Thing.new(1, 'A Thing')).as_json[:path].nil?
#raise if Thing.new(1, 'A Thing').cast_as(CastingApiAdapter).as_json[:path].nil?

Benchmark.bmbm do |x|
  x.report("Simple Inheritance") do
    ITERATIONS.times { InheritingApiAdapter.new(1, 'A Thing').as_json }
  end

  x.report("Module (via instance #extend)") do
    ITERATIONS.times { Thing.new(1, 'A Thing').tap {|t| t.extend(ModuleApiAdapter)}.as_json }
  end

  x.report("Module (via class-level include)") do
    ITERATIONS.times { ExtendedThing.new(1, 'A Thing').as_json }
  end

  x.report("Forwarding") do
    ITERATIONS.times { ForwardingApiAdapter.new(Thing.new(1, 'A Thing')).as_json }
  end

  x.report("SimpleDelegator") do
    ITERATIONS.times { SimpleDelegatorApiAdapter.new(Thing.new(1, 'A Thing')).as_json }
  end

  x.report("DelegateClass") do
    ITERATIONS.times { DelegateClassApiAdapter.new(Thing.new(1, 'A Thing')).as_json }
  end

#  x.report('Casting') do
#    ITERATIONS.times { Thing.new(1, 'A Thing').cast_as(CastingApiAdapter).as_json }
#  end
end

puts

# I'm not positive I need to be this convoluted, but refinement scopes are
# tricky...
class RefinedAdapterBenchmark
  using RefiningApiAdapter

  def benchmark
    raise if Thing.new(1, 'A Thing').as_json[:path].nil?

    Benchmark.bmbm do |x|
      x.report("Refinement (inline)") do
        ITERATIONS.times { Thing.new(1, 'A Thing').as_json }
      end
    end
  end
end
RefinedAdapterBenchmark.new.benchmark
