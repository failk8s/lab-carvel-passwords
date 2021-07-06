As has been demonstrated Starlark does not support the concept of modifiable
global variables, or at least any data is marked as read only once the module
the data is contained in has finished loading.

This is intentional given that Starlark is intended as a configuration
language and not a general purpose programming language. For the same reason,
even though Starlark is portrayed as a Python like language, it doesn't
support other concepts from Python, such as classes, which may have been
helpful in working around this restriction.

Our plans aren't foiled just yet, and these restrictions actually are a good
thing in that it forces development of a solution which would still ensure
deterministic and repeatable outputs.

For our next attempt, consider the random number generator found in the
``resources-v3/random.star`` file.

```editor:open-file
file: ~/exercises/resources-v3/random.star
```

This time we do not attempt to store state in the module, but require that
code needing to generate random numbers create a state object by first calling
``seed()``. This state object then needs to be passed to ``random()`` each
time it is called. This will generate a new random value and update the
supplied state object.

This module would be used as shown in ``resources-v3/secret-1.yaml``.

```editor:open-file
file: ~/exercises/resources-v3/secret-1.yaml
```

Run ``ytt`` to see the output which would be generated for this case.

```terminal:execute
command: ytt -f resources-v3/random.star -f resources-v3/secret-1.yaml -f resources-v3/values.yaml
```

The output should be something like.

```
apiVersion: v1
kind: Secret
metadata:
  name: mysecret-1
type: Opaque
stringData:
  password-1: "496694764"
  password-2: "956600491"
  password-3: "206321392"
```
