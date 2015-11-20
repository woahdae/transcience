# Fork of http://dec0de.me/2013/02/dci-performance/

# 
# Benchmark various dynamic object trait approaches in Ruby.
# 
# Not the prettiest script ever.
# Public domain.
# 
require 'delegate'
require 'benchmark'

COUNT = 100_000

# Test classes & modules

class MyClass
  def foo
    nil
  end

  def qux
    nil
  end
end

module MyMixin
  def bar
    nil
  end

  def qux
    nil
  end
end

class MyDelegator < DelegateClass(MyClass)
  def bar
    nil
  end

  def qux
    nil
  end
end

class WithInclude
  include MyMixin
end

# Benchmarked calls

def foo_normal_call
  MyClass.new.foo
end

def foo_with_extend
  MyClass.new.extend(MyMixin).foo
end

def foo_with_delegate
  MyDelegator.new(MyClass.new).foo
end

def bar_with_include
  WithInclude.new.bar
end

def bar_with_extend
  MyClass.new.extend(MyMixin).bar
end

def bar_with_delegate
  MyDelegator.new(MyClass.new).bar
end

def qux_with_include
  WithInclude.new.qux
end

def qux_with_extend
  MyClass.new.extend(MyMixin).qux
end

def qux_with_delegate
  MyDelegator.new(MyClass.new).qux
end

# Helpers

def disabled_gc
  return yield if defined?(JRUBY_VERSION)
  GC.enable
  GC.start
  GC.disable
  yield
end

def mem_usage
  `ps -p#{$$} -orss`.split[1].to_i
end

def run_benchmark
  disabled_gc { COUNT.times { yield } }
end

# Main

Benchmark.bmbm do |r|
  r.report("foo normal call")   { run_benchmark { foo_normal_call }   }
  r.report("foo with extend")   { run_benchmark { foo_with_extend }   }
  r.report("foo with delegate") { run_benchmark { foo_with_delegate } }

  r.report("bar with include")  { run_benchmark { bar_with_include }  }
  r.report("bar with extend")   { run_benchmark { bar_with_extend }   }
  r.report("bar with delegate") { run_benchmark { bar_with_delegate } }

  r.report("qux with include")  { run_benchmark { qux_with_include }  }
  r.report("qux with extend")   { run_benchmark { qux_with_extend }   }
  r.report("qux with delegate") { run_benchmark { qux_with_delegate } }
end
