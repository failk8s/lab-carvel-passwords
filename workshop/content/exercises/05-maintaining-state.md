As has been demonstrated Starlark does not support the concept of modifiable
global variables, or at least any data is marked as read only once the module
the data is contained in has finished loading.

This is intentional given that Starlark is intended as a configuration
language and not a general purpose programming language. For the same reason,
even though Starlark is portrayed as a Python like language, it doesn't
support other concepts from Python which may have been helpful in working
around this restriction.

Our plans aren't foiled just yet, and these restrictions actually are a good
thing in that it forces development of a solution which would still ensure
deterministic and repeatable outputs.
