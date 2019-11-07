# Strategies for invoking temporary behavior

What originally started out as an investigation into the (poorly named)
phenomenon dubbed [self-schizophrenia](https://en.wikipedia.org/wiki/Schizophrenia_(object-oriented_programming))
in view object wrappers like [Draper](https://github.com/drapergem/draper)
or [Sexy Presenter](https://github.com/kmdsbng/sexy_presenter) ended up as a
full-on investigation into many aspects of assigning temporary behavior
to objects in Ruby.

I already have an affinity for simple inheritance for this
purpose after reading [Growing Rails](https://leanpub.com/growing-rails),
but simple inheritance is limited to use cases where you only need to
assign a single operation to a single class.

I also have a dislike for decorators. They seem good on paper,
but have some serious suprises once you try using them. They're not the
"flexible alternative to subclassing" they're supposed to be.
Plus, popular decorator gems have Rails compatibility issues (ex.
Rails' view helpers don't play well with wrapped objects, nor with
HAML's CSS ID and class helpers).

So, what's a Rails developer left with? Is it best to beat a decorator
into submission with metaprogramming tricks? Live with the limitations of derocators?
How about `#extend` at runtime - good in theory, but doesn't it have huge performance issues?

You can just read the summary, and/or dive deeper into the
subdirectories. Each one has a README, so you won't have to do much
code spelunking.

### Summary

If you're using Ruby 2.1 or later, don't avoid `#extend` for performance
reasons. It's now at least as performant as delegation, maybe better,
and there is no risk of invalidating your class cache like in earlier
versions of Ruby.

If you're using Ruby 2.0 or earlier, favor a delegation strategy and
deal with the fallout. You'll need to do things like ex.
copy/paste HAML's `underscore` into your delegators' `haml_object_ref`
method, and other hacks. But it's the best there is, pre-2.1.

### Dive Deeper

* [the comparison directory](comparison) contains many implementations
  of wrapper objects, and unit tests that assert the various things we
  want to be true of a wrapper object. Not all the tests pass, since
  not all strategies provide everything we want. The comparison README
  summarizes my findings.
* [the avdi directory](avdi) implements [Avdi Grimm's article on delegators](http://devblog.avdi.org/2012/01/31/decoration-is-best-except-when-it-isnt/)
  with tests. I just wanted to see the issues for myself.
* [the webapp directory](webapp) implements a Rails app using
  [Draper](https://github.com/drapergem/draper) to see if it suffers
  from issues with the delegator pattern I've experienced in my own
  home-grown SimpleDelegator-based presenter implementations. The webapp
  README has screenshots showing what I found.
* [the extend_perf_test directory](extend_perf_test) follows up on many
  popular but dated blog posts on the topic of `#extend` performance.
  The extend_perf_test README summarizes the results.

