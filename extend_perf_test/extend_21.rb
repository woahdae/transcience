# My own extend tests

require 'benchmark'

FIZZ = 'fizz'
BUZZ = 'buzz'
MOO  = 'moo'

class Foo
  def buzz
    BUZZ
  end
end

class Bar < Foo
end

class Baz < Bar
end

class Zab < Baz
end

class Rab < Zab
end

class Moo
  def buzz
    MOO
  end
end

module Fizz
  def buzz
    FIZZ
  end
end

def measure_busted_caches(description)
  baseline_serial = RubyVM.stat(:class_serial)
  yield
  new_serial = RubyVM.stat(:class_serial)
  puts "#{description} busted #{new_serial - baseline_serial} cached classes"
end

measure_busted_caches("Extending top-level object of 5-member hierarchy") do
  Foo.new.extend(Fizz).buzz
end

measure_busted_caches("Extending leaf-level object of 5-member hierarchy") do
  Rab.new.extend(Fizz).buzz
end

measure_busted_caches("Extending only object of 1-member hierarchy") do
  Moo.new.extend(Fizz).buzz
end

measure_busted_caches("Extending Object instance") do
  Object.new.extend(Fizz).buzz
end

measure_busted_caches("Extending Object class") do
  def Object.foo
    FOO
  end
end

puts
puts "Perf test:"
puts

ITERATIONS = 100_000

Benchmark.bmbm do |r|
  r.report("Plain allocation")                                          { ITERATIONS.times { Foo.new } }
  r.report("Plain allocation, with dispatch")                           { ITERATIONS.times { Foo.new.buzz } }
  r.report("Extending leaf class of 5-member hierarchy")                { ITERATIONS.times { Rab.new.extend(Fizz) } }
  r.report("Extending leaf class of 5-member hierarchy, with dispatch") { ITERATIONS.times { Rab.new.extend(Fizz).buzz } }
  r.report("Extending root class of 5-member hierarchy")                { ITERATIONS.times { Foo.new.extend(Fizz) } }
  r.report("Extending root class of 5-member hierarchy, with dispatch") { ITERATIONS.times { Foo.new.extend(Fizz).buzz } }
  r.report("Extending 1-member hierarchy")                              { ITERATIONS.times { Moo.new.extend(Fizz) } }
  r.report("Extending 1-member hierarchy, with dispatch")               { ITERATIONS.times { Moo.new.extend(Fizz).buzz } }
  r.report("Extending object")                                          { ITERATIONS.times { Object.include(Fizz); Foo.new } }
  r.report("Extending object, with dispatch")                           { ITERATIONS.times { Object.include(Fizz); Foo.new.buzz } }
end
