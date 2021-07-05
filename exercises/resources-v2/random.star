load("@ytt:data", "data")
load("@ytt:json", "json")

__globals__ = {
  "seed": 0
}

def seed(value=None):
   current = __globals__["seed"]
   if value != None:
     __globals__["seed"] = value
   end
   return current
end

def random():
   value = hash(str(seed()))
   value = -value if value < 0 else value
   seed(value)
   return value
end

print("DEBUG: random() =", random())
print("DEBUG: random() =", random())
print("DEBUG: random() =", random())
