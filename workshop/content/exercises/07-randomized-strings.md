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

As example of usage can be found in ``resources-v4/secret-1.yaml``.

```editor:open-file
file: ~/exercises/resources-v4/secret-1.yaml
```

Run ``ytt`` of this example:

```terminal:execute
command: ytt -f resources-v4/random.star -f resources-v4/secret-1.yaml
```

and the output should be:

```
apiVersion: v1
kind: Secret
metadata:
  name: mysecret-1
type: Opaque
stringData:
  password-1: 6C#SePk7SZf=8?DY
  password-2: RA8pP!jb
  token-1: WHS0zjOlfcxg9gomOSVtELtIlBNeWav4Cjrq1ONSPsCtH3vVUiQz0i2QoB0gQytC
  token-2: NQtiTYelx2lSOTIKAeYHa8YSKm7wyBgl
  hostname-1: shiny-pond-0556
  hostname-2: shy-heart-e57bd525ae
```

As before, the master seed can still be changed and all generated values will
be affected, with:

```terminal:execute
command: ytt -f resources-v4/random.star -f resources-v4/secret-1.yaml -v seed=1234567890
```

generating:

```
apiVersion: v1
kind: Secret
metadata:
  name: mysecret-1
type: Opaque
stringData:
  password-1: eW4nMcM87%^R3$vB
  password-2: 32mnFEsR
  token-1: mRcfWAQ4Di8blmRITCMHLOmFxrLqvSGc0lJxKMyfSFTRxKfIQcRV4bVwP7fa2m84
  token-2: EeW7huYUBcopSMFCYwSeH3d3MkoXao7m
  hostname-1: noisy-glade-8179
  hostname-2: nameless-union-3c8d1d0d4e
  ```
