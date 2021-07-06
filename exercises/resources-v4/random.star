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

def choice(state, seq):
  return seq[random(state)%len(seq)]
end

def password(state, length=16):
  password_chars = "23456789abcdefghjkmnpqrstuvwxyzABCDEFGHJKMNPQRSTUVWXYZ!#$%&*+-=?@^_"
  return "".join([choice(state, password_chars) for _ in range(length)])
end

def token(state, length=64, token_chars=None):
  if token_chars == None:
    token_chars = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
  end
  return "".join([choice(state, token_chars) for _ in range(length)])
end

_adjectives = [
    'aged', 'ancient', 'autumn', 'billowing', 'bitter', 'black', 'blue',
    'bold', 'broad', 'broken', 'calm', 'cold', 'cool', 'crimson', 'curly',
    'damp', 'dark', 'dawn', 'delicate', 'divine', 'dry', 'empty', 'falling',
    'fancy', 'flat', 'floral', 'fragrant', 'frosty', 'gentle', 'green',
    'hidden', 'holy', 'icy', 'jolly', 'late', 'lingering', 'little', 'lively',
    'long', 'lucky', 'misty', 'morning', 'muddy', 'mute', 'nameless', 'noisy',
    'odd', 'old', 'orange', 'patient', 'plain', 'polished', 'proud', 'purple',
    'quiet', 'rapid', 'raspy', 'red', 'restless', 'rough', 'round', 'royal',
    'shiny', 'shrill', 'shy', 'silent', 'small', 'snowy', 'soft', 'solitary',
    'sparkling', 'spring', 'square', 'steep', 'still', 'summer', 'super',
    'sweet', 'throbbing', 'tight', 'tiny', 'twilight', 'wandering',
    'weathered', 'white', 'wild', 'winter', 'wispy', 'withered', 'yellow',
    'young'
]

_nouns = [
    'art', 'band', 'bar', 'base', 'bird', 'block', 'boat', 'bonus', 'bread',
    'breeze', 'brook', 'bush', 'butterfly', 'cake', 'cell', 'cherry', 'cloud',
    'credit', 'darkness', 'dawn', 'dew', 'disk', 'dream', 'dust', 'feather',
    'field', 'fire', 'firefly', 'flower', 'fog', 'forest', 'frog', 'frost',
    'glade', 'glitter', 'grass', 'hall', 'hat', 'haze', 'heart', 'hill',
    'king', 'lab', 'lake', 'leaf', 'limit', 'math', 'meadow', 'mode', 'moon',
    'morning', 'mountain', 'mouse', 'mud', 'night', 'paper', 'pine', 'poetry',
    'pond', 'queen', 'rain', 'recipe', 'resonance', 'rice', 'river', 'salad',
    'scene', 'sea', 'shadow', 'shape', 'silence', 'sky', 'smoke', 'snow',
    'snowflake', 'sound', 'star', 'sun', 'sun', 'sunset', 'surf', 'term',
    'thunder', 'tooth', 'tree', 'truth', 'union', 'unit', 'violet', 'voice',
    'water', 'waterfall', 'wave', 'wildflower', 'wind', 'wood'
]

def haikunate(state, delimiter='-', token_length=4, token_hex=False, token_chars='0123456789'):
  if token_hex:
    token_chars = '0123456789abcdef'
  end

  adjective = choice(state, _adjectives)
  noun = choice(state, _nouns)
  suffix = token(state, token_length, token_chars)

  return delimiter.join([adjective, noun, suffix])
end
