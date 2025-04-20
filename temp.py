table = {
    'a': '!', 'b': '"', 'c': '#', 'd': '$', 'e': '%', 'f': '&', 'g': "'", 'h': '(', 'i': ')', 'j': '*', 
    'k': '+', 'l': ',', 'm': '-', 'n': '.', 'o': '/', 'p': ':', 'q': ';', 'r': '<', 's': '=', 't': '>', 
    'u': '?', 'v': '@', 'w': '0', 'x': '1', 'y': '2', 'z': '3'
}

def convert_string(s):
    return ''.join(table.get(c, c) for c in s)

# Example usage
uobf_str = str(input("Type Your Unobfuscated Text: ")).lower()
obf_str = convert_string(uobf_str)
print(obf_str)