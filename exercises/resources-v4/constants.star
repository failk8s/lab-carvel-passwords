load("/random.star", "seed", "password")

state = seed("mysecret-2")

secret = password(state)
