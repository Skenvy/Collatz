# Under the CC-BY-SA-4.0, https://creativecommons.org/licenses/by-sa/4.0/

RGBA_NAMES_MAP = {
    'Alpha Black': (0, 0, 0, 0),
    'Full Black': (0, 0, 0, 255),
    'Alpha White': (255, 255, 255, 0),
    'Full White': (255, 255, 255, 255),
    'Original off black': (5, 7, 8, 255),
    'Yellow': (255, 255, 0, 255), # #FFFF00
    'Red': (255, 0, 0, 255), # #FF0000

    ##### Go #####
    # Primary
    'Gopher Blue': (1, 173, 216, 255), #00ADD8
    'Go Light Blue': (94, 201, 227, 255), #5DC9E2
    'Go Aqua': (0, 162, 156, 255), #00A29C
    # Secondary
    'Go Fuchsia': (206, 48, 98, 255), #CE3262
    'Go Yellow': (253, 221, 0, 255), #FDDD00
    # "More"
    'Go Darker Aqua': (0, 117, 141, 255), #00758D
    'Go Indigo': (64, 43, 86, 255), #402B56

    ##### Java #####
    # Primary Blue and Orange
    'Java Blue': (0, 115, 150, 255),
    'Java Blue (Older)': (83, 130, 161, 255), #5382A1
    'Java Blue (Uncoated)': (84, 138, 153, 255),
    'Java Orange': (237, 139, 0, 255),
    'Java Orange (Older)': (255, 165, 24, 255), #FFA518
    'Java Orange (Uncoated)': (255, 163, 0, 255),
    # Oracle / Duke Reds
    'Oracle Red': (199, 70, 52, 255), #C74634
    'Java Duke Red': (179, 8, 56, 255), #B30838
    # Other top JVM's linguist colours for accents
    'Linguist Java': (176, 114, 25, 255),
    'Linguist Kotlin': (169, 123, 255, 255), #A97BFF
    'Linguist Scala': (194, 45, 64, 255), #C22D40
    'Linguist Groovy': (66, 152, 184, 255), #4298B8
    'Linguist Clojure': (219, 88, 85, 255), #DB5855

    ##### JavaScript #####
    # JavaScript Colours
    'JavaScript Yellow': (241, 224, 90, 255), #F1E05A
    'TypeScript Yellow': (241, 221, 53, 255), #F1DD35
    'ColourJS Yellow': (247, 223, 30, 255), #F7DF1E
    # TypeScript Branding https://www.typescriptlang.org/branding/
    'TypeScript Blue': (49, 120, 198, 255), #3178C6
    'TypeScript Blue 2nd 1': (53, 142, 241, 255), #358EF1
    'TypeScript Blue 2nd 2': (35, 90, 151, 255), #235A97
    # NodeJS Greens https://nodejs.org/static/documents/foundation-visual-guidelines.pdf
    'NodeJS Green': (68, 136, 62, 255), # PANTONE 7741 C
    'Pantone 360 C': (108, 194, 74, 255),
    'Pantone 357 C': (33, 87, 50, 255),
    # NPM Red https://github.com/npm/logos
    'NPM Red': (193, 33, 39, 255), #C12127
    'NPM Chrome Rasterisation': (181, 51, 21, 255), #B53315
}

_ = RGBA_NAMES_MAP

################################################################################
# Palettes.

# _CSHARP_PALETTE = [ # TODO
#     (1, {_['COLOUR NAME']: 6}),
# ]

_GO_PALETTE = [
    (6, {_['Gopher Blue']: 6, _['Go Light Blue']: 3, _['Go Aqua']: 1}),
    (3, {_['Go Fuchsia']: 5, _['Go Yellow']: 5}),
    (1, {_['Go Darker Aqua']: 5, _['Go Indigo']: 5}),
]

_JAVA_PALETTE = [
    (3, {_['Java Blue']: 6}, _['Java Blue (Older)']: 3, _['Java Blue (Uncoated)']: 1),
    (3, {_['Java Orange']: 6}, _['Java Orange (Older)']: 3, _['Java Orange (Uncoated)']: 1),
    (2, {_['Java Duke Red']: 6}, _['Oracle Red']: 3, _['Red']: 1),
    (1, {_['Linguist Kotlin']: 1}, _['Linguist Scala']: 1, _['Linguist Groovy']: 1, _['Linguist Clojure']: 1),
]

_JAVASCRIPT_PALETTE = [
    (1, {_['JavaScript Yellow']: 6, _['ColourJS Yellow']: 3, _['TypeScript Yellow']: 1}),
    (1, {_['TypeScript Blue']: 6, _['TypeScript Blue 2nd 1']: 3, _['TypeScript Blue 2nd 2']: 1}),
    (1, {_['NodeJS Green']: 6, _['Pantone 360 C']: 3, _['Pantone 357 C']: 1}),
    (1, {_['NPM Red']: 6, _['NPM Chrome Rasterisation']: 3, _['Red']: 1})
]

# _JULIA_PALETTE = [
#     (1, {_['COLOUR NAME']: 6}),
# ]

# _LATEX_PALETTE = [
#     (1, {_['COLOUR NAME']: 6}),
# ]

# _PYTHON_PALETTE = [
#     (1, {_['COLOUR NAME']: 6}),
# ]

# _R_PALETTE = [
#     (1, {_['COLOUR NAME']: 6}),
# ]

# _RUBY_PALETTE = [
#     (1, {_['COLOUR NAME']: 6}),
# ]

# _RUST_PALETTE = [ # TODO
#     (1, {_['COLOUR NAME']: 6}),
# ]

# _MAIN_DARK_PALETTE = [
#     (1, {_['COLOUR NAME']: 6}),
# ]

# _MAIN_LIGHT_PALETTE = [
#     (1, {_['COLOUR NAME']: 6}),
# ]

################################################################################
# Group all palettes.

PALETTES = {
    # 'CSharp': _CSHARP_PALETTE, # TODO
    'Go': _GO_PALETTE,
    'Java': _JAVA_PALETTE,
    'JavaScript': _JAVASCRIPT_PALETTE,
    # 'Julia': _JULIA_PALETTE,
    # 'LaTeX': _LATEX_PALETTE,
    # 'Python': _PYTHON_PALETTE,
    # 'R': _R_PALETTE,
    # 'Ruby': _RUBY_PALETTE,
    # 'Rust': _RUST_PALETTE, # TODO
    # 'Main_dark': _MAIN_DARK_PALETTE,
    # 'Main_light': _MAIN_LIGHT_PALETTE,
}
