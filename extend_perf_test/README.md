# Performance testing instance extension

In the comparison section of this project, several strategies for
implementing temporary behavior are analyzed with respect to
self-schizophrenia. There we see the strategies following principles of
least surprise - ones that maintain some sort of inheritance identity
and intuitive method dispatch - are all inheritance or refinement based.

One of the most feature-full and flexible solutions is extending
instances at run-time. Unfortunately, as of this writing, all front-page
articles and comments talking about this strategy point out a
performance deal-breaker: according to them, extending instances breaks
the global method cache!!! Crazy.

The good news is Ruby 2.1 fixes this issue. The bad news is Ruby 2.1
doesn't fix all the extend-related FUD from many popular articles on the
subject.

So, what's the real story with extending instances at run-time in Ruby
2.1+? Let's measure to find out.

# Results

### The short version

TL;DR, extending an object instance has a *very* miniscule performance
hit and no longer affects the global object cache in Ruby 2.1.

**Feel free to use `#extend` at will!**

### The long version

According to the tests included here, using `#extend` will invalidate 3
class caches no matter how deep the hierarchy, and is a one-time
*tiny* performance hit that does not affect subsequent method dispatch.

In fact, although not measured here, it's probably more performant than ex.
`method_missing`-based solutions like SimpleDelegate that must
constantly do more expensive dispatch operations on each method call.

**Three data sources support these claims:**

### 1

[This gist by Github user "raggi"](https://gist.github.com/raggi/4704522)
tries to reflect real-world usage of extend while a process is doing other
method dispatch, and reports performance degrades as much as 2x compared to
using a simple delegation strategy. I re-ran this perf test, and see no
effect whatsoever of extending an object. All cases run in roughly the same
amount of time, even in the longest-running cases (where previously the
performance difference was most pronounced).

This directory's [bm_dci_pounding.rb](bm_dci_pounding.rb) is a fork of that gist.
  
### 2

[This blog post](http://dec0de.me/2013/02/dci-performance/) measures many
rubies, including MRI up to 1.9.3-p374. It finds SimpleDelegator to be faster
than `#extend`, whereas running the script in Ruby 2.1, I find extend to be
slightly faster (SimpleDelegate is a slow delegation strategy in general,
since it relies on `method_missing`).

This directory's [bench.rb](bench.rb) is a reproduction of this posts' test.
  
### 3

My own tests are in [extend_21.rb](extend_21.rb), and measure both the cache impact of

extending objects in various inheritance hierarchies, including Object, and
performance tests to go along. The perf tests also address whether any
performance hit comes from dispatch vs just extending an object.

A representative output is shown below. The summary is that extending an instance
consistently busts exactly 3 caches (not sure why 3) and extending Object does
indeed seem to bust a lot of caches. Any performance hit from extending an
object is shown to be in the act of extension, not in subsequent dispatch,
since no differences in dispatch times between all the strategies were
observed.

      [git/master-]:extend_perf_test% ruby bench_21.rb

      Extending top-level object of 5-member hierarchy busted 3 cached classes
      Extending leaf-level object of 5-member hierarchy busted 3 cached classes
      Extending only object of 1-member hierarchy busted 3 cached classes
      Extending Object instance busted 3 cached classes
      Extending Object class busted 261 cached classes

      Perf test:

      Rehearsal ---------------------------------------------------------------------------------------------
      Plain allocation                                            0.020000   0.000000   0.020000 (  0.016878)
      Plain allocation, with dispatch                             0.020000   0.000000   0.020000 (  0.018537)
      Extending leaf class of 5-member hierarchy                  0.220000   0.010000   0.230000 (  0.225268)
      Extending leaf class of 5-member hierarchy, with dispatch   0.230000   0.000000   0.230000 (  0.239379)
      Extending root class of 5-member hierarchy                  0.220000   0.010000   0.230000 (  0.222212)
      Extending root class of 5-member hierarchy, with dispatch   0.220000   0.000000   0.220000 (  0.228243)
      Extending 1-member hierarchy                                0.230000   0.010000   0.240000 (  0.237234)
      Extending 1-member hierarchy, with dispatch                 0.240000   0.000000   0.240000 (  0.241528)
      Extending object                                            0.040000   0.000000   0.040000 (  0.042283)
      Extending object, with dispatch                             0.040000   0.000000   0.040000 (  0.036521)
      ------------------------------------------------------------------------------------ total: 1.510000sec

                                                                      user     system      total        real
      Plain allocation                                            0.010000   0.000000   0.010000 (  0.013337)
      Plain allocation, with dispatch                             0.020000   0.000000   0.020000 (  0.018189)
      Extending leaf class of 5-member hierarchy                  0.150000   0.000000   0.150000 (  0.153233)
      Extending leaf class of 5-member hierarchy, with dispatch   0.160000   0.000000   0.160000 (  0.158743)
      Extending root class of 5-member hierarchy                  0.160000   0.000000   0.160000 (  0.162263)
      Extending root class of 5-member hierarchy, with dispatch   0.160000   0.010000   0.170000 (  0.167901)
      Extending 1-member hierarchy                                0.160000   0.000000   0.160000 (  0.159861)
      Extending 1-member hierarchy, with dispatch                 0.160000   0.010000   0.170000 (  0.164935)
      Extending object                                            0.030000   0.000000   0.030000 (  0.031226)
      Extending object, with dispatch                             0.040000   0.000000   0.040000 (  0.036580)

