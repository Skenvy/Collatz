# Under the CC-BY-SA-4.0, https://creativecommons.org/licenses/by-sa/4.0/

RGBA_NAMES_MAP = {
    'Alpha Black': (0, 0, 0, 0),
    'Full Black': (0, 0, 0, 255),
    'Alpha White': (255, 255, 255, 0),
    'Full White': (255, 255, 255, 255),
    'Original off black': (5, 7, 8, 255),
    'Yellow': (255, 255, 0, 255), # #FFFF00
    'Red': (255, 0, 0, 255), # #FF0000

    'JavaScript Yellow': (241, 224, 90, 255), # #F1E05A
    'TypeScript Yellow': (241, 221, 53, 255), # #F1DD35
    'ColourJS Yellow': (247, 223, 30, 255), # #F7DF1E
    # TypeScript Branding https://www.typescriptlang.org/branding/
    'TypeScript Blue': (49, 120, 198, 255), # #3178C6
    'TypeScript Blue 2nd 1': (53, 142, 241, 255), # #358EF1
    'TypeScript Blue 2nd 2': (35, 90, 151, 255), # #235A97
    # NodeJS Greens https://nodejs.org/static/documents/foundation-visual-guidelines.pdf
    'NodeJS Green': (68, 136, 62, 255), # PANTONE 7741 C
    'Pantone 360 C': (108, 194, 74, 255),
    'Pantone 357 C': (33, 87, 50, 255),
    # NPM Red https://github.com/npm/logos
    'NPM Red': (193, 33, 39, 255), # #C12127
    'NPM Chrome Rasterisation': (181, 51, 21, 255), # #B53315
}

_ = RGBA_NAMES_MAP

################################################################################
# Palettes.

_CSHARP_PALETTE = [
    (1, {_['COLOUR NAME']: 6}),
]

_GO_PALETTE = [
    (1, {_['COLOUR NAME']: 6}),
]

_JAVA_PALETTE = [
    (1, {_['COLOUR NAME']: 6}),
]

_JAVASCRIPT_PALETTE = [
    (1, {_['JavaScript Yellow']: 6, _['ColourJS Yellow']: 3, _['TypeScript Yellow']: 1}),
    (1, {_['TypeScript Blue']: 6, _['TypeScript Blue 2nd 1']: 3, _['TypeScript Blue 2nd 2']: 1}),
    (1, {_['NodeJS Green']: 6, _['Pantone 360 C']: 3, _['Pantone 357 C']: 1}),
    (1, {_['NPM Red']: 6, _['NPM Chrome Rasterisation']: 3, _['Red']: 1})
]

_JULIA_PALETTE = [
    (1, {_['COLOUR NAME']: 6}),
]

_LATEX_PALETTE = [
    (1, {_['COLOUR NAME']: 6}),
]

_PYTHON_PALETTE = [
    (1, {_['COLOUR NAME']: 6}),
]

_R_PALETTE = [
    (1, {_['COLOUR NAME']: 6}),
]

_RUBY_PALETTE = [
    (1, {_['COLOUR NAME']: 6}),
]

_RUST_PALETTE = [
    (1, {_['COLOUR NAME']: 6}),
]

_MAIN_DARK_PALETTE = [
    (1, {_['COLOUR NAME']: 6}),
]

_MAIN_LIGHT_PALETTE = [
    (1, {_['COLOUR NAME']: 6}),
]

################################################################################
# Group all palettes.

PALETTES = {
    # 'CSharp': _CSHARP_PALETTE,
    # 'Go': _GO_PALETTE,
    # 'Java': _JAVA_PALETTE,
    'JavaScript': _JAVASCRIPT_PALETTE,
    # 'Julia': _JULIA_PALETTE,
    # 'LaTeX': _LATEX_PALETTE,
    # 'Python': _PYTHON_PALETTE,
    # 'R': _R_PALETTE,
    # 'Ruby': _RUBY_PALETTE,
    # 'Rust': _RUST_PALETTE,
    # 'Main_dark': _MAIN_DARK_PALETTE,
    # 'Main_light': _MAIN_LIGHT_PALETTE,
}
