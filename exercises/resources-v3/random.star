load("@ytt:data", "data")
load("@ytt:json", "json")

def seed(value=None):
  return { "value": json.encode((data.values.seed, value)) }
end

def random(seed):
  value = hash(seed["value"])
  value = -value if value < 0 else value
  seed["value"] = str(value)
  return value
end
