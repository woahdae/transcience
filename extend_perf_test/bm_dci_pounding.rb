# https://gist.github.com/raggi/4704522
require 'benchmark'

number_of_rails_methods = 1000

@rails = Class.new do
  number_of_rails_methods.times do |i|
    class_eval <<-RUBY
      def call#{"%02d" % i}    # def call01
      end                   # end
    RUBY
  end
end.new

many_calls = Array.new(number_of_rails_methods) do |i|
  "@rails.call#{'%02d' % i}"
end.join("\n")

eval <<-RUBY
def rails_does_other_stuff
#{many_calls}
end
RUBY

Person = Struct.new(:first_name, :last_name)

class DelegateDecorator
  def initialize(target)
    @target = target
  end

  def method_missing(n, *a, &b)
    @target.__send__(n, *a, &b)
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end

module DCIDecorator
  def self.new(object)
    object.extend(self)
    object
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end

many = 100000

puts "# #{many} iterations"
puts "# #{number_of_rails_methods} non-decorated calls"

Benchmark.bmbm(20) do |r|

  r.report("plain dispatch") do
    many.times do
      person = Person.new("joe", "smith")
      rails_does_other_stuff
    end
  end

  r.report("some delegator") do
    many.times do
      person = Person.new("joe", "smith")
      decorated = DelegateDecorator.new(person)
      decorated.first_name
      decorated.full_name
      rails_does_other_stuff
    end
  end

  r.report("some dci decorator") do
    many.times do
      person = Person.new("joe", "smith")
      decorated = DCIDecorator.new(person)
      decorated.first_name
      decorated.full_name
      rails_does_other_stuff
    end
  end
end
