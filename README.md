# Demonstrating self-schizophrenia

### The problem

As full-stack object-oriented developers who are practicing something
along the lines of domain-driven design, we often want to give our
domain objects temporary or contextual attributes or behavior.

For example, our API might add the resource URI in a models' `#to_json`,
a view might want to have view-specific defaults or formatting.

Wrapper objects in general are a very popular solution. Whether they're
called presenters, decorators, delegators, or view models, they all
share the basic goal of providing temporary or contextual behavior fit
only for a specific scenario.

The problem with wrapper objects is twofold, and can be summarized as
"self-schizophrenia" - an object with two concepts of 'self.'

The first way this manifests a problem is in class and inheritance
hierarchies of the wrapper vs the wrapped object. This is especially
problematic in Rails, where the framework and supporting libraries try
to manifest useful behavior based on object names and inheritance
hierarchies. For example, `dom_id` helpers in Rails and HAML use class
names to auto-generate HTML classes and ids, but will mis-identify wrapper objects.
In general the wrapper will seem like a drop-in replacement, since the
wrapper indeed "quacks like a duck," but since it will happily tell you it's
not any kind of duck, a good number of libraries will be confused.

The second way this manifests a problem is in unintuitive method dispatch.
Calling a method directly on the wrapper will always execute the correct
method, either calling the method on the wrapper or delegating to the wrapped object.
However, any method calls the wrapped object makes internally will be
called on itself, the wrapped object, not on the wrapper. This makes
sense, because the whole point is that the wrapped object has no
knowledge of the wrapper, but is yet another way subtle bugs can creep
in as soon as you're not keeping both objects in mind.

For these reasons, giving an object temporary behavior by wrapping it
with another object is not ideal. Even when it works for a simple case,
like presenting a product with a dollar sign in front of the price,
you're employing a strategy that we know won't scale to more complex
uses, and might even trip up libraries or other developers in the simple
case!

### This project

This project demonstrates various ways of giving an object temporary or
contextual behavior, and where each strategy succeeds or fails according
to these criteria:

An object granted temporary or contextual behavior should:

* Still be within its class hierarchy
* Dispatch methods in the context of the applied behavior first

In this project the problem is looked at from multiple angles, and in
each case tests have been written to see what satisfies which criteria.
Note that the tests don't all pass, and this is intentional. A test
failure represents a failure of the strategy to meet our criteria.

First, the "comparison" directory provides examples of granting
temporary behavior via:

* Forwarding via `Forwardable` module
* Delegating via `SimpleDelegator`
* Multiple uses of refinements

We also know simple inheritance would satisfy our requirements, but
would also limit us to a single behavior at a time. This was not in the
comparison since it's uninteresting to test, but not because it's a
horrible idea.

Next, the "avdi" directory is a copy/paste of [Avdi Grimm's article on self-schizophrenia](http://devblog.avdi.org/2012/01/31/decoration-is-best-except-when-it-isnt/), plus tests to show what works with delegation and what doesn't (as his blog article also spells out).

Finally, the "webapp" directary is a Ruby project using wrapper
libraries for view presenters, namely Draper. Draper is wildly popular,
but as I suspected, does still exhibit all the pitfalls of delegation.
Actually, the exercise of creating a view with Draper made me realize
maybe it's a nice feature that the decorators can't modify model
behavior, but I still think it's conceptually simpler to not have the
self-split.


