Up till now for the passwords we have been using the integer number returned
by the random number generator as the password. In a real deployment we will
want to use a randomized string of characters instead. Having a random number
generator we can easily build a library of functions on top for generating
various types of randomized strings.

For one implementation see ``resources-v4/random.star``.

```editor:open-file
file: ~/exercises/resources-v4/random.star
```

Here we have a few different functions available. The first is one to generate
password including both letters, numbers and symbols.

```editor:select-matching-text
file: ~/exercises/resources-v4/random.star
text: "def password(.*):"
isRegex: true
after: 3
```

This is an opinionated password generator, leaving out certain letters and
symbols that can be ambiguous when read.

The next is a more generic token generator where the set of characters used
can be overridden if required.

```editor:select-matching-text
file: ~/exercises/resources-v4/random.star
text: "def token(.*):"
isRegex: true
after: 5
```

The final function is a Heroku style name generator often used for hostname
generation.

```editor:select-matching-text
file: ~/exercises/resources-v4/random.star
text: "def haikunate(.*):"
isRegex: true
after: 10
```

As example of usage can be found in ``resources-v4/secret.yaml``.

```editor:open-file
file: ~/exercises/resources-v4/secret.yaml
```

Run ``ytt`` of this example:

```terminal:execute
command: ytt -f resources-v4/
```

and the output should be:

```
apiVersion: v1
kind: Secret
metadata:
  name: mysecret
type: Opaque
stringData:
  password-1: 97aFzFMj86GJ5A_D
  password-2: HvgEka@d
  token-1: c5Fyqk2ydSPKThLFUN4GlJVSdyjhmOANzFAokHoAXWsKrOEZveifGPxLhabF8Tdh
  token-2: L1pp0IK8h7qQTczdamN2tImhyUPfpWjH
  hostname-1: rough-dawn-4505
  hostname-2: noisy-sun-e502dbd9c2
```

As before, the master seed can still be changed and all generated values will
be affected, with:

```terminal:execute
command: ytt -f resources-v4/ -v seed=1234567890
```

generating:

```
apiVersion: v1
kind: Secret
metadata:
  name: mysecret
type: Opaque
stringData:
  password-1: dvBFHMhmU2VvRTfy
  password-2: SgcKteE_
  token-1: SEs7qB3x9qFE02W5q08E3DmKEcer0lE8Aix5IN3LHqfdpJQyjtgEsZRoXrDolqpV
  token-2: 4YHyAOi46TlKS7QZxw33zvL0t9PwWVWG
  hostname-1: jolly-moon-2987
  hostname-2: misty-grass-4885caaa87
  ```
