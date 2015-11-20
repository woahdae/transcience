# Comparison of strategies to implement temporary behavior

This simulates a domain model exposed via an API using an adapter
concept. The adapter represents the temporary or contextual need to
express a domain model according to a particular paradigm, namely a json
resource providing all the attributes of the domain model *plus* a
resource identifier (in this case just a path, to keep it simple).

In order to highlight innate differences between the strategies, all are
implemented in the most naive way; thus, some work, and others don't.

For example, only about half of the strategies manage to extend the json
representation with the `path` property, and the
[casting](https://github.com/saturnflyer/casting) strategy in particular
doesn't even override `#as_json`.

### Feature Matrix

As a result of running the tests, here is a condensed feature matrix:

Strategy                         | Add method     | Override method | Keep binding        | Keep class hierarchy
---------------------------------|----------------|-----------------|---------------------|---------------------
Simple Inheritance               | :green_heart:  | :green_heart:   | :green_heart:       | :green_heart:
Refinement (inline)              | :green_heart:  | :green_heart:   | :green_heart:       | :green_heart:
Module (via class-level include) | :green_heart:  | :green_heart:   | :green_heart:       | :green_heart:
Module (via instance #extend)    | :green_heart:  | :green_heart:   | :green_heart:       | :green_heart:
Forwarding                       | :green_heart:  | :green_heart:   | :broken_heart:      | :broken_heart:
DelegateClass                    | :green_heart:  | :green_heart:   | :broken_heart:      | :broken_heart:
SimpleDelegator                  | :green_heart:  | :green_heart:   | :broken_heart:      | :broken_heart:
Casting                          | :green_heart:  | :broken_heart:  | ? (need <- to test) | :green_heart:

### Performance Results

#### Real-ish-world example

First, note that when running the perf tests with `#slug` doing string
manipulation, all strategies are pretty close. Delegators and module
extension take a bit longer than simple method calls, but it's not
crazy:

Strategy                         | Time (seconds)
---------------------------------|---------------
Simple Inheritance               | 0.08
Module (via class-level include) | 0.08
Forwarding                       | 0.08
DelegateClass                    | 0.09
SimpleDelegator                  | 0.10
Module (via instance #extend)    | 0.11

(100,000 iterations each)

In a sense this is a better real-world test, but it begs the question:
what happens if it's *just* module extension and method dispatch?

#### Extend-focused example

So, to test the various strategies absent of other variables, I modified
all `slug` methods to just return the name, made all `as_json` methods
just call super, then ran [measure_performance.rb](measure_performance.rb)
a bunch of times, and eyeballed the averages into this table. *NOT VERY
SCIENTIFIC*, but still interesting.

Strategy                         | Time (seconds)
---------------------------------|---------------
Simple Inheritance               | 0.10
Refinement (inline)              | 0.10
Module (via class-level include) | 0.10
Forwarding                       | 0.12
DelegateClass                    | 0.21
SimpleDelegator                  | 0.23
Casting                          | 0.26
Module (via instance #extend)    | 0.35

(100,000 iterations each)

This matches my expectations coming in to the test, but includes a
couple learning points too.

### Takeaways

First, I'm glad to see refinements don't add any measurable overhead.

Next, Inheritance, both simple class inheritance and multiple
inheritance, are also equally fast. I would be highly suspicious of my
tests if this wasn't true.

Then it's interesting to see that forwarding is about 2x faster in this
test that delegation. Also, SimpleDelegator was always just a tiiiiny
bit slower than DelegateClass - huh. Not anything that matters, I just
figured they'd be in a dead heat.

Finally, [casting](https://github.com/saturnflyer/casting) and module
extension represent the slow end of the test, which also makes sense.
Casting is rebinding methods, and `#extend` is messing around with the
inheritance hierarchy of each instance. Still, casting isn't much slower
here than delegation.
