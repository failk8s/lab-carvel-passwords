We have deterministic output which is one of the goals, but the problem is
that the state object we created only exists for the scope of processing
that one file. This means that for a separate resource we are going to end
up with the same set of random numbers being generated.

So if we have another secret as shown in ``resources-v3/secret-1b.yaml``
where the only difference is the name of the resource:

```editor:open-file
file: ~/exercises/resources-v3/secret-1b.yaml
```

and run ``ytt`` on this and the first one at the same time:

```terminal:execute
command: ytt -f resources-v3/random.star -f resources-v3/secret-1a.yaml -f resources-v3/secret-1b.yaml -f resources-v3/values.yaml
```

we get:

```
apiVersion: v1
kind: Secret
metadata:
  name: mysecret-1a
type: Opaque
stringData:
  password-1: "496694764"
  password-2: "956600491"
  password-3: "206321392"
---
apiVersion: v1
kind: Secret
metadata:
  name: mysecret-1b
type: Opaque
stringData:
  password-1: "496694764"
  password-2: "956600491"
  password-3: "206321392"
```

The solution to this is to supply different values for each when calling
``seed()`` to generate the state object used by ``random()``. This can be
seen in ``resources-v3/secret-2.yaml``.

```editor:open-file
file: ~/exercises/resources-v3/secret-2.yaml
```

Here we have supplied the string value ``mysecret-2`` as input to ``seed()``.
Run ``ytt`` again using this file in place of the copy:

```terminal:execute
command: ytt -f resources-v3/random.star -f resources-v3/secret-1a.yaml -f resources-v3/secret-2.yaml -f resources-v3/values.yaml
```

and we get:

```
apiVersion: v1
kind: Secret
metadata:
  name: mysecret-1a
type: Opaque
stringData:
  password-1: "496694764"
  password-2: "956600491"
  password-3: "206321392"
---
apiVersion: v1
kind: Secret
metadata:
  name: mysecret-2
type: Opaque
stringData:
  password-1: "1369957268"
  password-2: "1622952094"
  password-3: "196539994"
```

Thus we have a separate set of random numbers generated for that file but
everytime we process the files we will still get the same output.

Now although the values are random they are deterministic, so if passwords
were compromised we need an easy way of quickly changing them. Having to
go into each resource and change the value passed to ``seed()`` isn't really
viable.

To solve this problem the implementation caters for the concept of their
being a master seed value. This is defined as being one of the data input
values as seen in ``resources-v3/values.yaml``.

```editor:open-file
file: ~/exercises/resources-v3/values.yaml
```

To change all generated passwords in one go, one need only override this
seed value when running ``ytt``.

```terminal:execute
command: ytt -f resources-v3/random.star -f resources-v3/secret-1a.yaml -f resources-v3/secret-2.yaml -f resources-v3/values.yaml -v seed=1234567890
```

The output for both secrets is now:

```
apiVersion: v1
kind: Secret
metadata:
  name: mysecret-1a
type: Opaque
stringData:
  password-1: "1058782614"
  password-2: "65401162"
  password-3: "950085847"
---
apiVersion: v1
kind: Secret
metadata:
  name: mysecret-2
type: Opaque
stringData:
  password-1: "426520046"
  password-2: "306590697"
  password-3: "1978286335"
```

The master seed affects everything, but as the argument to ``seed()`` can be
any value and not just a constant string, it is possible to link a seed state
to other input data input values. This is demonstrated in
``resources-v3/secret-3.yaml``.

```editor:open-file
file: ~/exercises/resources-v3/secret-3.yaml
```

This time the input for the seed is ``("mysecret-3", data.values.secret)`` and
so combines a local string value for identification, but also the ``secret``
value from the data input values.

Run ``ytt`` this time on the last secret we used and this new one.

```terminal:execute
command: ytt -f resources-v3/random.star -f resources-v3/secret-2.yaml -f resources-v3/secret-3.yaml -f resources-v3/values.yaml
```

The output should be:

```
apiVersion: v1
kind: Secret
metadata:
  name: mysecret-2
type: Opaque
stringData:
  password-1: "1369957268"
  password-2: "1622952094"
  password-3: "196539994"
---
apiVersion: v1
kind: Secret
metadata:
  name: mysecret-3
type: Opaque
stringData:
  password-1: "1261652644"
  password-2: "539311775"
  password-3: "2061836291"
```

Now override just the data input value for ``secret`` rather than the master seed value.

```terminal:execute
command: ytt -f resources-v3/random.star -f resources-v3/secret-2.yaml -f resources-v3/secret-3.yaml -f resources-v3/values.yaml -v secret=1234567890
```

This time you should see:

```
apiVersion: v1
kind: Secret
metadata:
  name: mysecret-2
type: Opaque
stringData:
  password-1: "1369957268"
  password-2: "1622952094"
  password-3: "196539994"
---
apiVersion: v1
kind: Secret
metadata:
  name: mysecret-3
type: Opaque
stringData:
  password-1: "1033520162"
  password-2: "669333017"
  password-3: "1361039964"
```

Thus only the passwords generated for ``mysecret-3`` are changed.

If you wanted to, instead of using a specific data value, you could also used
``data.values`` as input to ``seed()``. That is, all data input values. This
way any change to the configuration would trigger different random values to
be generated.

Not only do we have a deterministic way of generating the same random values
for the same input, we have an easy way of being able to force the generation
of different random values through a master seed, or selectively if desired
by tying the seed input values for a specific instance to a different data
input value.
