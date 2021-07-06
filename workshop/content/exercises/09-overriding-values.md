Although having automatically generated values can be convenient and
simplifies the generation of a set of deployment resources, it shouldn't be
relied on as the only solution. When using generated values it is always going
to be good practice to allow them to be overridden through the data input
values when running ``ytt``.

For how this can be done check out ``resources-v4/secret-3.yaml``.

```editor:open-file
file: ~/exercises/resources-v4/secret-3.yaml
```

You can see how it will check for the password being defined as a data input
value and if it is use that, but otherwise generate a password.

Running ``ytt`` on this:

```terminal:execute
command: ytt -f resources-v4/random.star -f resources-v4/secret-3.yaml -f resources-v4/values.yaml
```

we get:

```
apiVersion: v1
kind: Secret
metadata:
  name: mysecret-3
type: Opaque
stringData:
  password-1: WvYGh*s$k5kB@kxY
  password-2: tqySB7zF8_43_pkQ
```

Now override the password using a data input value:

```terminal:execute
command: ytt -f resources-v4/random.star -f resources-v4/secret-3.yaml -f resources-v4/values.yaml -v password1=top-secret
```

which should yield:

```
apiVersion: v1
kind: Secret
metadata:
  name: mysecret-3
type: Opaque
stringData:
  password-1: top-secret
  password-2: WvYGh*s$k5kB@kxY
```

You may not appreciate it, but this actually presents a problem. Because we
replaced the first of the two generated passwords by overriding it, this had
the side effect of causing the subsequent password to be changed. In this
case it actually ended up being set to what the first password was set to.

This sort of outcome is not desirable as far as ensuring deterministic
behaviour as we only really want the one password to be overridden and
everything else left as is.

To remedy this problem we need to ensure that we still always generate
every password and only after we do this override it with a supplied value.
This ensures everything else stays the same.

This version can been see in ``resources-v4/secret-4.yaml``.

```terminal:execute
command: ytt -f resources-v4/random.star -f resources-v4/secret-4.yaml -f resources-v4/values.yaml
```

Processing this with ``ytt``:

```terminal:execute
command: ytt -f resources-v4/random.star -f resources-v4/secret-4.yaml -f resources-v4/values.yaml
```

we get:

```
apiVersion: v1
kind: Secret
metadata:
  name: mysecret-3
type: Opaque
stringData:
  password-1: WvYGh*s$k5kB@kxY
  password-2: tqySB7zF8_43_pkQ
```

which is the same as we had for the prior version, but overriding the password:

```terminal:execute
command: ytt -f resources-v4/random.star -f resources-v4/secret-4.yaml -f resources-v4/values.yaml -v password1=top-secret
```

now yields:

```
apiVersion: v1
kind: Secret
metadata:
  name: mysecret-3
type: Opaque
stringData:
  password-1: top-secret
  password-2: tqySB7zF8_43_pkQ
```

with only the overridden password being replaced.
