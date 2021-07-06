load("@ytt:data", "data")
load("@ytt:json", "json")

__globals__ = {
  "seed": ""
}

def random():
  value = hash(__globals__["seed"])
  value = -value if value < 0 else value
  __globals__["seed"] = str(value)
  return value
end

print("DEBUG: random() =", random())
print("DEBUG: random() =", random())
print("DEBUG: random() =", random())
