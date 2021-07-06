The [FAQ](https://carvel.dev/ytt/docs/latest/faq/#can-i-generate-random-strings-with-ytt)
for ``ytt`` includes the entry:

> **Can I generate random strings with ytt?**
> No. A design goal of ytt is determinism, which keeps randomness out of scope.

One purpose of this workshop was to have a discussion to show that randomness
need not be all evil.

Yes, tools like Helm have problems but this is because they surface a standard
API for accessing random numbers with no constraints on how it can be used.

Hopefully in this workshop you can see that a system for generating random
values rooted in the concept of needing to be driven by defined seeds can
provide a reasonable middle ground that can make some tasks more convenient as
a fallback behaviour, but where best practice would still be to inject
passwords and other generated secrets as data input values from an external
source.

As a result I personally believe that ``ytt`` should provide the ability to
generate random numbers, passwords, tokens and other generated data.

Key to making this work and not resulting in people shooting themselves in the
foot is to document well the best conventions as to how to make use of such a
feature, much like I have covered the various issues in this workshop. So long
as you do this it can be a valuable feature for those who heed the guidelines
to ensure that the goal of deterministic output can still be achieved.

To that end I would like to see a builtin ``random`` module with a similar
interface to what I described for ``seed()`` and ``random()``. The random
number generator could then use a more robust implementation, included
directly in ``ytt`` and not using a library, so that you are guaranteed it
doesn't change suddenly resulting in existing output being broken if the
sequence of random numbers generated changes.

As to the concept of a master seed, for that I would like to see ``ytt`` have
a command line option ``--seed`` for overriding the default. This way you
don't end up with the problem of whatever data value name you use clashing
with a user trying to use the same name. Being a command line option makes
it more visible and not just some hidden feature that no one knows about.

I would also like to see more builtin modules for hash generation. Currently
only ``sha256`` is supported, but there are other commonly used algorithms for
where applications expect hashed data. I would also like to see ``sha1``,
``bcrypt`` and ``argon2`` supported.

As explained in this [Carvel
issue](https://github.com/vmware-tanzu/carvel-ytt/issues/106) related to
``bcrypt`` support this can mean requiring a random number generator to
generate salt values. In that issue though it pushes towards that being passed
in as a data value, although if the system for random number generation as
explained in this workshop were used, it could rely on it instead.

Stressing once more though, including all this is as a convenience which would
make things easier when dealing with what to do as a default. It would not do
away with the idea that things like passwords, or hashed password database
entries should be passed in from an external source if you want to do things
in the best way possible.
