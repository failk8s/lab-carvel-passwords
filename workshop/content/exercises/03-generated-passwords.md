With the configuration for the ``ytt`` templates currently used it is
necessary to provide the password from an external source. This is going to
be the most secure way of handling passwords, but as far as usability is
concerned it is extra work.

With this approach you also have to ensure you supply the same password if
updating the configuration or resources later if upgrading else you could
overwrite the original secret value with the password with a different value.
This can be a problem where the secret served as the documentation for what
the password was, but an application separately stored it when first deployed
for later use. Here the value in the secret and what the application used
clould get out of sync and you could loose access to your application if you
hadn't saved away the original password separately.

Where as with ``ytt`` we have to supply the password, other template systems
available for Kubernetes have a way to automatically generate randomized
values for template fields, such as passwords, if not supplied.

One example of such a system is templates in OpenShift, Red Hat's distribution
of Kubernetes. This ability can be quite convenient for many applications
where you don't usually care about the password. The system can generate the
password for you, and you would only seek out the password from the secret
if you absolutely had to.

For OpenShift this works fine because templates are usually only applied once
in the overall lifecycle of an application deployment. That is, the template
is a starter used to generate all the initial Kubernetes resources, but after
that if you want to make changes you would edit the raw Kubernetes resources
directly. You therefore don't encounter the problem that processing the
template a second time can result in different generated values.

This is not necessarily the case however when using Helm templates, which also
have a means to generate randomized values for template inputs when not
supplied. In the case of Helm templates, processing the template when
performing an upgrade will result in a different value of a password being
generated.

To cope with this situation when using Helm templates it is upon the author
of the Helm template to add logic to their template to detect when it is
being used to perform an upgrade, versus an initial install, and when it is
an upgrade query back the original value of a password from the currently
deployed secret and reuse it, or skip setting a new value at all.

This mechanism will only work where the Helm client is being used to perform
an upgrade directly against the cluster. It will not work when using Helm
as a standalone client to generate the Kubernetes resources which are then
later applied to the cluster using ``kubectl apply`` or ``kapp``.

Because of problems like this that can arise, ``ytt`` doesn't provide any
builtin features for generate random values. Instead it takes the view that
the set of resources created should be deterministic, and that running ``ytt``
should always produce the same output for the same data input values.

That said, this doesn't mean that it isn't possible to generate randomized
values when using ``ytt`` and the next part of this workshop will explain how
it can actually done. In presenting this solution, it will be shown that even
though randomized values are generated, it can still be made deterministic, or
at least to a level which is adequate for simple uses cases.
