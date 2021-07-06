In order to generate randomized values we need a random number generator.
Neither ``ytt`` itself, or the Starlark programming language that ``ytt`` uses
to implement logic in templates supports one.

To workaround a lack of such builtin functionality we need to implement our
own random number generator as a Starlark module. This doesn't need to be an
optimal random number generator as usually we would only need to generate a
relatively small number of random numbers. Thus if we can get any measure of
randomness, it likely will be sufficient.

With that goal, consider the first attempt at a random number generator found
in the ``random.star`` file.

```editor:open-file
file: ~/exercises/resources-v2/random.star
```

The general approach is to start with a seed value and each time the random
number generator is called, generate a new value from the seed value, return
that as the random value, but also update the seed value based on that random
value.

For this we use the fact that the ``hash()`` function in Starlark will
generate an integer value from a string. The trick used is therefore to
convert the existing seed from an integer to a string and generate a hash
value from it. The absolute value of the hash is returned as the random
number and the hash stored as the new seed.

It isn't necessarily the most sophisticated random number generator but will
suffice for this disucssion.

Before moving on and trying it, you may see something strange happening with
the ``__globals__`` variable.

The reason for this is that Starlark doesn't permit functions to update
literal values at global scope in a module. In other words, it doesn't support
the analogous ``global`` keyword from Python.

The workaround for this is to create a dictionary as a global variable and
use it to hold state variables required.

Now lets look at a YAML template file which attempts to use this module.

```editor:open-file
file: ~/exercises/resources-v2/secret.yaml
```

It imports the ``random`` module, calling ``random()`` to generate a value,
converting that to a string value to store in the secret.

Processing this though with ``ytt``:

```terminal:execute
command: ytt -f resources-v2/
```

we get:

```
DEBUG: random() = 0
DEBUG: random() = 48
DEBUG: random() = 1668
DEBUG: random() = 0
DEBUG: random() = 48
DEBUG: random() = 1668
ytt: Error: 
- cannot insert into frozen hash table
    in random
      11 |   __globals__["seed"] = str(value)
    in <toplevel>
      secret.yaml:10 |   password: #@ str(random())
```

There are two issues here.

The first is apparent from the debug statements we left in the code of the
module. That is, it appears the module is imported and processed twice, even
though we only use it once.

This is a bit odd, but otherwise doesn't appear in itself to affect any use of
Starlark modules by ``ytt``. It is not obvious if this is a bug in how ``ytt``
uses Starlark. One would have expected the module to only be imported and
processed once.

The bigger problem though derives from how Starlark modules work.

The issue here is that once a module has been loaded, all global variables,
and recursively any data structures referred to by those global variables are
frozen. In other words everything in the module becomes read only.

As a consequence, even though our random number generator appeared to do the
right thing when called in the context of the module when being loaded, once
the module loading has finished, it no longer works as the seed value cannot
be updated between calls.
