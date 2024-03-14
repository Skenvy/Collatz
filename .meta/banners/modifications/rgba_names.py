# Under the CC-BY-SA-4.0, https://creativecommons.org/licenses/by-sa/4.0/

RGBA_NAMES_MAP = {
    ##### Generic #####
    # Meta
    'Alpha Black': (0, 0, 0, 0),
    'Full Black': (0, 0, 0, 255),
    'Alpha White': (255, 255, 255, 0),
    'Full White': (255, 255, 255, 255),
    'Original off black': (5, 7, 8, 255),
    # Primary
    'Blue': (0, 0, 255, 255),
    'Green': (0, 255, 0, 255),
    'Purple': (255, 0, 255, 255),
    'Red': (255, 0, 0, 255),
    'Yellow': (255, 255, 0, 255),
    # Secondary
    'Blue 2': (0, 0, 204, 255),
    'Green 2': (0, 204, 0, 255),
    'Green 3': (0, 153, 0, 255),
    'Purple 2': (204, 0, 204, 255),
    'Red 2': (204, 0, 0, 255),

    ##### C# #####
    # TODO

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

    ##### Julia #####
    # Primary
    'Julia Blue': (64, 99, 216, 255), #4063D8
    'Julia Green': (56, 152, 38, 255), #389826
    'Julia Purple': (148, 88, 178, 255), #9558B2
    'Julia Red': (203, 60, 51, 255), #CB3C33
    # Only two secondaries are sufficiently different
    'Julia Forest Green': (34, 139, 34, 255), #228B22
    'Julia Medium Orchid': (180, 82, 205, 255), #B452CD

    ##### LaTeX #####
    # TODO

    ##### Python #####
    'Python Blue Light': (90, 159, 212, 255), #5a9fd4
    'Python Blue Mid': (69, 132, 182, 255),
    'Python Blue Dark': (48, 105, 152, 255), #306998
    'Python Yellow Light': (255, 232, 115, 255), #ffe873
    'Python Yellow Mid': (255, 222, 87, 255),
    'Python Yellow Dark': (255, 212, 59, 255), #ffd43b

    ##### R #####
    'R Blue Light': (39, 109, 195, 255),
    'R Blue Mid': (30, 100, 182, 255),
    'R Blue Dark': (22, 92, 170, 255),
    'R Grey Light': (203, 206, 208, 255),
    'R Grey Mid': (167, 168, 173, 255),
    'R Grey Dark': (132, 131, 139, 255),

    ##### Ruby #####
    'Ruby Darkest Red 1': (121, 19, 13), #79130D <
    'Ruby Darkest Red 2': (121, 28, 18), #791C12
    'Ruby Darkest Red 3': (126, 14, 8), #7E0E08
    'Ruby Darkest Red 4': (126, 17, 11), #7E110B
    'Ruby Darkest Red 5': (128, 14, 8), #800E08
    'Ruby Darkest Red 6': (130, 12, 1), #820C01
    'Ruby Dark Red 1': (135, 17, 1), #871101
    'Ruby Dark Red 2': (139, 33, 20), #8B2114
    'Ruby Dark Red 3': (140, 12, 1), #8C0C01 <
    'Ruby Dark Red 4': (145, 15, 8), #910F08
    'Ruby Dark Red 5': (145, 18, 9), #911209
    'Ruby "Red 3" 1': (153, 0, 0), #990000 = "Red 3"
    'Ruby "Red 3" 2': (153, 12, 0), #990C00
    'Ruby "Red 3" 3': (158, 12, 0), #9E0C00
    'Ruby "Red 3" 4': (158, 16, 10), #9E100A
    'Ruby "Red 3" 5': (158, 18, 9), #9E1209
    'Ruby "Red 3" 6': (158, 18, 11), #9E120B
    'Ruby Regular Darker 1': (163, 12, 0), #A30C00
    'Ruby Regular Darker 2': (163, 22, 1), #A31601
    'Ruby Regular Darker 3': (166, 0, 3), #A60003
    'Ruby Regular Darker 4': (168, 13, 0), #A80D00
    'Ruby Regular Darker 5': (168, 13, 14), #A80D0E
    'Ruby Regular Mid 1': (179, 16, 0), #B31000
    'Ruby Regular Mid 2': (179, 19, 1), #B31301
    'Ruby Regular Mid 3': (179, 16, 12), #B3100C
    'Ruby Regular Lighter 1': (189, 0, 18), #BD0012 <
    'Ruby Regular Lighter 2': (191, 9, 5), #BF0905
    'Ruby Regular Lighter 3': (191, 25, 11), #BF190B
    'Ruby Regular Lighter 4': (190, 26, 13), #BE1A0D
    'Ruby Light Red 1': (200, 31, 17), #C81F11
    'Ruby Light Red 2': (200, 36, 16), #C82410
    'Ruby Light Red 3': (200, 47, 28), #C82F1C
    'Ruby Lightest Red 1': (232, 38, 9), #E82609 <
    'Ruby Lightest Red 2': (228, 43, 30), #E42B1E
    'Ruby Lightest Red 3': (222, 59, 32), #DE3B20
    'Ruby Lightest Red 4': (222, 64, 36), #DE4024
    'Ruby Light Orange 1': (228, 99, 66), #E46342
    'Ruby Light Orange 2': (228, 113, 78), #E4714E
    'Ruby Light Orange 3': (229, 114, 82), #E57252
    'Ruby Light Orange 4': (251, 118, 85), #FB7655

    ##### Rust #####
    # TODO
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
    (3, {_['Java Blue']: 6, _['Java Blue (Older)']: 3, _['Java Blue (Uncoated)']: 1}),
    (3, {_['Java Orange']: 6, _['Java Orange (Older)']: 3, _['Java Orange (Uncoated)']: 1}),
    (2, {_['Java Duke Red']: 6, _['Oracle Red']: 3, _['Red']: 1}),
    (1, {_['Linguist Kotlin']: 1, _['Linguist Scala']: 1, _['Linguist Groovy']: 1, _['Linguist Clojure']: 1}),
]

_JAVASCRIPT_PALETTE = [
    (1, {_['JavaScript Yellow']: 6, _['ColourJS Yellow']: 3, _['TypeScript Yellow']: 1}),
    (1, {_['TypeScript Blue']: 6, _['TypeScript Blue 2nd 1']: 3, _['TypeScript Blue 2nd 2']: 1}),
    (1, {_['NodeJS Green']: 6, _['Pantone 360 C']: 3, _['Pantone 357 C']: 1}),
    (1, {_['NPM Red']: 6, _['NPM Chrome Rasterisation']: 3, _['Red']: 1})
]

_JULIA_PALETTE = [
    (1, {_['Julia Purple']: 6, _['Julia Medium Orchid']: 3, _['Purple 2']: 1}),
    (1, {_['Julia Green']: 6, _['Julia Forest Green']: 3, _['Green 3']: 1}),
    (1, {_['Julia Red']: 6, _['Red']: 3, _['Red 2']: 1}),
    (1, {_['Julia Blue']: 6, _['Blue']: 3, _['Blue 2']: 1}),
]

# _LATEX_PALETTE = [ # TODO
#     (1, {_['COLOUR NAME']: 6}),
# ]

_PYTHON_PALETTE = [
    (1, {_['Python Yellow Light']: 2, _['Python Yellow Mid']: 6, _['Python Yellow Dark']: 2}),
    (1, {_['Python Blue Light']: 2, _['Python Blue Mid']: 6, _['Python Blue Dark']: 2}),
]

_R_PALETTE = [
    (1, {_['R Blue Light']: 2, _['R Blue Mid']: 6, _['R Blue Dark']: 2}),
    (1, {_['R Grey Light']: 2, _['R Grey Mid']: 6, _['R Grey Dark']: 2}),
]

_RUBY_PALETTE = [
    (1, {_['Ruby Darkest Red 1']: 5, _['Ruby Darkest Red 2']: 1, _['Ruby Darkest Red 3']: 1, _['Ruby Darkest Red 4']: 1, _['Ruby Darkest Red 5']: 1, _['Ruby Darkest Red 6']: 1}),
    (1, {_['Ruby Dark Red 1']: 1, _['Ruby Dark Red 2']: 1, _['Ruby Dark Red 3']: 6, _['Ruby Dark Red 4']: 1, _['Ruby Dark Red 5']: 1}),
    (1, {_['Ruby "Red 3" 1']: 5, _['Ruby "Red 3" 2']: 1, _['Ruby "Red 3" 3']: 1, _['Ruby "Red 3" 4']: 1, _['Ruby "Red 3" 5']: 1, _['Ruby "Red 3" 6']: 1}),
    (1, {_['Ruby Regular Darker 1']: 6, _['Ruby Regular Darker 2']: 1, _['Ruby Regular Darker 3']: 1, _['Ruby Regular Darker 4']: 1, _['Ruby Regular Darker 5']: 1}),
    (1, {_['Ruby Regular Mid 1']: 1, _['Ruby Regular Mid 2']: 1, _['Ruby Regular Mid 3']: 1}),
    (1, {_['Ruby Regular Lighter 1']: 7, _['Ruby Regular Lighter 2']: 1, _['Ruby Regular Lighter 3']: 1, _['Ruby Regular Lighter 4']: 1}),
    (1, {_['Ruby Light Red 1']: 1, _['Ruby Light Red 2']: 1, _['Ruby Light Red 3']: 1}),
    (1, {_['Ruby Lightest Red 1']: 7, _['Ruby Lightest Red 2']: 1, _['Ruby Lightest Red 3']: 1, _['Ruby Lightest Red 4']: 1}),
    (1, {_['Ruby Light Orange 1']: 1, _['Ruby Light Orange 2']: 1, _['Ruby Light Orange 3']: 1, _['Ruby Light Orange 4']: 1}),
]

# _RUST_PALETTE = [ # TODO
#     (1, {_['COLOUR NAME']: 6}),
# ]

# _MAIN_DARK_PALETTE = [ # TODO
#     (1, {_['COLOUR NAME']: 6}),
# ]

# _MAIN_LIGHT_PALETTE = [ # TODO
#     (1, {_['COLOUR NAME']: 6}),
# ]

################################################################################
# Group all palettes.

PALETTES = {
    # 'CSharp': _CSHARP_PALETTE, # TODO
    'Go': _GO_PALETTE,
    'Java': _JAVA_PALETTE,
    'JavaScript': _JAVASCRIPT_PALETTE,
    'Julia': _JULIA_PALETTE,
    # 'LaTeX': _LATEX_PALETTE, # TODO
    'Python': _PYTHON_PALETTE,
    'R': _R_PALETTE,
    'Ruby': _RUBY_PALETTE,
    # 'Rust': _RUST_PALETTE, # TODO
    # 'Main_dark': _MAIN_DARK_PALETTE, # TODO
    # 'Main_light': _MAIN_LIGHT_PALETTE, # TODO
}
