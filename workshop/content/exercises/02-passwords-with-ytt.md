Because best practice for managing deployment of applications is to keep any
configuration such as Kubernetes resources under source code control, needing
to embed the value of a secret within a secret resource definition is
problematic.

Specifically, you want to avoid committing the resource including the value
for the secret back to your source code repository, especially where that is a
public respository. Doing so can accidentally expose your application to
attack as anyone could access passwords defined in the secret. The value of a
secret being ``base64`` encoded isn't going to help due to it being trivial to
decode it.

When dealing with raw Kubernetes resources this means having to instead
dynamically generate the secret at the time of deployment using ``kubectl
create secret``, or manually, and apply it to the cluster. This means
requiring an extra step in any deployment procedures.

When using the Carvel tools to manage deployment of an application, we can
still have the secret resource definition under source code control, but can
use the template mechanism of ``ytt`` to substitute the value of the secret
at the time of deployment. This can be seen in the ``secret.yaml`` file of
our first example.

```editor:select-matching-text
file: ~/exercises/resources-v1/secret.yaml
text: "password:"
before: 0
after: 0
```

As can be seen, the value of the password is expected to be supplied as a data
input value when running ``ytt``. The definition of that data value being
specified in the ``values.yaml`` file.

```editor:select-matching-text
file: ~/exercises/resources-v1/values.yaml
text: "password:"
before: 0
after: 0
```

Note that although we have specified a password data value is required, we
haven't supplied a default value. With the value being ``null``, when ``ytt``
is run it will fail as a string value is going to be expected.

```terminal:execute
command: ytt -f resources-v1/
```

To set the password we can instead supply the data value on the command line
when ``ytt`` is run:

```terminal:execute
command: ytt -f resources-v1/ -v password=top-secret
```

although this isn't actually recommended since the command line will be saved
in the shell history and the password could thus be discovered later.

The recommended method therefore is to create a separate values file and
reference it when running ``ytt``.

```terminal:execute
command: ytt -f resources-v1/ -f values-v1.yaml
```

This separate values file would never be added to the source code repository
and would only be kept on the secure machine where you run the deployment
from, or may only even be created just to do the deployment and then deleted
immediately after.
