Because the seed state for the random number generator needs to be created
and held where it is used, this can present a problem where the random value
is required to be inserted into multiple resources.

One solution to this is to have the different resources defined in the same
YAML file, although you need to ensure that the value is only generated once
and saved to a global variable which is then inserted into each resource. This
is demonstrated in ``resources-v4/secret-2.yaml``.

```editor:open-file
file: ~/exercises/resources-v4/secret-2.yaml
```

Run ``ytt`` on this example:

```terminal:execute
command: ytt -f resources-v4/random.star -f resources-v4/secret-2.yaml
```

and you should get:

```
apiVersion: v1
kind: Secret
metadata:
  name: mysecret-2a
type: Opaque
stringData:
  password: wJWjpfKPQv+j2Ped
---
apiVersion: v1
kind: Secret
metadata:
  name: mysecret-2b
type: Opaque
stringData:
  password: wJWjpfKPQv+j2Ped
```

If you don't want to place the resources in the same file, you can instead
create a Starlark module where you generate any global contstants for the
generated values. This can then be loaded where ever it is required.
Because the module is marked read only once first loaded there is no risk
the value can change.

An example of this can be found in ``resources-v4/constants.star``:

```editor:open-file
file: ~/exercises/resources-v4/constants.star
```

with it used by ``resources-v4/secret-2c.yaml``.

```editor:open-file
file: ~/exercises/resources-v4/secret-2c.yaml
```

Executing ``ytt`` on the files:

```terminal:execute
command: ytt -f resources-v4/random.star -f resources-v4/constants.star -f resources-v4/secret-2c.yaml
```

yields the same result:

```
apiVersion: v1
kind: Secret
metadata:
  name: mysecret-2c
type: Opaque
stringData:
  password: wJWjpfKPQv+j2Ped
```

It was the same value here as we used the same input value when generating the
seed, and although you could do that in each resource file as well,
centralising the value in a constants module means you only have to change one
place when implementing changes related to the generated values.
