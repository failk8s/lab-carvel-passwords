load("@ytt:data", "data")
load("@ytt:json", "json")

def seed(value=None):
  master = getattr(data.values, "seed") if data.values else None
  return { "value": json.encode((master, value)) }
end

def random(state):
  value = hash(state["value"])
  value = -value if value < 0 else value
  state["value"] = str(value)
  return value
end
