def hta(hex_color, is_bg=False):
    hex_color = str(hex_color).lstrip('#').lower()  # Ensure string and remove "#"

    # Fix black color issue
    if hex_color == "000000":
        hex_color = "b9bbbe"

    # Convert hex to RGB
    r, g, b = [int(hex_color[i:i+2], 16) for i in (0, 2, 4)]

    # Convert to ANSI 256-color
    r_index = round(r / 51)
    g_index = round(g / 51)
    b_index = round(b / 51)
    ansi_code = 16 + (36 * r_index) + (6 * g_index) + b_index

    return f"\033[{48 if is_bg else 38};5;{ansi_code}m"

def rcolor():
    return "\033[0m"