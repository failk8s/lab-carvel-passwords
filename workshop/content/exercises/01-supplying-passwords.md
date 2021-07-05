When deploying an application they will often require configuration to set
user access passwords for administrators and REST API clients, or to set
access tokens which are used to setup trusted communication paths between
components of the application.

When using static Kubernetes resources this means having to add the password
or token into the Kubernetes resource definition used to supply it to the
application.

For Kubernetes the resource type which should be used to supply passwords in
this way should be a secret, although if dealing with an operator, this might
instead need to be passed using a custom resource.

For the case of using a Kubernetes secret, the resource definition would be:

```
apiVersion: v1
kind: Secret
metadata:
  name: mysecret
type: Opaque
stringData:
  password: top-secret
```

In defining the secret we have in this case used the ``stringData`` property
to hold the secret values. This allows us to supply the values of any secrets
in plain text. The alternative is to use the ``data`` property, in which case
we would need to use:

```
apiVersion: v1
kind: Secret
metadata:
  name: mysecret
type: Opaque
data:
  password: dG9wLXNlY3JldA==
```

The encoded value in this case isn't any sort of magic encyption and is
instead just ``base64`` encoded.

Whichever way is used, after the secret has been created in the cluster
querying back the resource will always show data in the latter form, with the
value shown as being ``base64`` encoded, albeit that that can easily be
decoded to get the original value.

Note that even when stored in the Kubernetes cluster no encryption is done on
the values of secrets. In fact the only extra guarantees that are provided in
respect of secrets over other resources is that they will never be stored on
the disk of any worker nodes in the cluster and instead will only be kept in
memory. This ensures that if a node is removed from a cluster and the machine
disposed of, that someone couldn't read the secrets from the node filesystem
retained on disk were the disk not wiped correctly.
