load("@ytt:data", "data")
load("@ytt:json", "json")
load("@ytt:md5", "md5")

__globals__ = {
  "seed": hash(json.encode(data.values))
}

def seed(value=None):
   current = __globals__["seed"]
   if value != None:
     __globals__["seed"] = value
   end
   return current
end

def random():
   value = md5.sum(str(seed()))
   value = hash(value)
   value = -value if value < 0 else value
   seed(value)
   return value
end
