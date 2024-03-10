#!/usr/bin/env python

# Under the CC-BY-SA-4.0, https://creativecommons.org/licenses/by-sa/4.0/

import os
from PIL import Image
from math import floor

from rgba_names import RGBA_NAMES_MAP as COLOURS, PALETTES
from contiguities import CONTIGUITIES

ORIGINAL_PATH = '../ORIGINAL.png'
BLANK_PATH = './_blank.png'

################################################################################
#### Functions used to assess how close a partial colouring was to a target ####
################################################################################

def load_image(path):
    with Image.open(path) as src:
        (width, height) = src.size
        pixels = src.load()
    return (pixels, width, height)

def pixel_type_counts(pixels, width, height):
    pixel_type = {}
    for x in range(width):
        for y in range(height):
            pixel_type[pixels[x,y]] = pixel_type.get(pixels[x,y], 0) + 1
    return pixel_type

def alias_colour_names_keyed_dict(dict_whose_keys_are_colour_tuples, map_rgba_names=COLOURS):
    for map_to, map_from in map_rgba_names.items():
        if map_from in dict_whose_keys_are_colour_tuples.keys():
            dict_whose_keys_are_colour_tuples[map_to] = dict_whose_keys_are_colour_tuples.pop(map_from)
    return dict_whose_keys_are_colour_tuples

def pixel_ratios(pixels, width, height, map_rgba_names={'Alpha Black': COLOURS['Alpha Black']},
                 disregard_colours=[COLOURS['Alpha Black'], COLOURS['Alpha White'], COLOURS['Full Black']]):
    pixel_types = pixel_type_counts(pixels, width, height)
    img_size = width*height
    for colour in disregard_colours:
        if colour in pixel_types.keys():
            img_size -= pixel_types.pop(colour)
    pixel_types = alias_colour_names_keyed_dict(pixel_types, map_rgba_names=map_rgba_names)
    for key in pixel_types.keys():
        pixel_types[key] = round(100*pixel_types[key]/img_size, 2)
    return {k: v for k, v in sorted(pixel_types.items(), key=lambda item: item[1], reverse=True)}

def report_pixel_ratios(image_path):
    (img, w, h) = load_image(image_path)
    ratios = pixel_ratios(img, w, h, map_rgba_names=COLOURS)
    for k, v in ratios.items():
        print(f'{k}: {v}')

# Converts "meta ratios" into a single dict of ratios.
# meta_ratios = [('outer ratio of this set', {'colour name xyz': 'inner ratio', ...}), ...]
def totalise_percentage_meta_ratios(meta_ratios):
    total_ratios = {}
    # Normalise inner ratios first
    for (outer_ratio, inner_ratios) in meta_ratios:
        new_inner_ratios = {k: 100*v/sum(inner_ratios.values()) for k, v in inner_ratios.items()}
        for k, v in new_inner_ratios.items():
            inner_ratios[k] = v
    # Now add them up to the total ratios
    for (outer_ratio, inner_ratios) in meta_ratios:
        for colour, inner_ratio in inner_ratios.items():
            total_ratios[colour] = outer_ratio*inner_ratio + total_ratios.get(colour, 0)
    sum_ratios = sum(total_ratios.values())
    for colour, ratio in total_ratios.items():
        total_ratios[colour] = round(100*ratio/sum_ratios)
    return total_ratios

def how_to_reach_ratios(image_path, desired_ratios):
    (img, w, h) = load_image(image_path)
    actual_ratios = pixel_ratios(img, w, h, map_rgba_names=COLOURS)
    total_percentages = alias_colour_names_keyed_dict(totalise_percentage_meta_ratios(desired_ratios))
    for colour in [colour for colour in actual_ratios.keys() if colour not in total_percentages.keys()]:
        print(f'Found colour {colour} present that is not desired at all. Remove all {actual_ratios[colour]}% of it!')
    for colour, target_percent in total_percentages.items():
        if target_percent == actual_ratios.get(colour, 0):
            print(f'Colour {colour} is at its desired percentage {target_percent}% already. Do nothing with it.')
        elif target_percent > actual_ratios.get(colour, 0):
            print(f'Colour {colour} is LESS than its desired percentage {target_percent}% already. Add more of it.')
        else:
            print(f'Colour {colour} is MORE than its desired percentage {target_percent}% already. Remove some of it.')

################################################################################
## Functions for recreating the uncoloured blank image, and contiguities list ##
################################################################################

def recolour_image(path, new_path, recolour_map):
    with Image.open(path) as src:
        (width, height) = src.size
        pixels = src.load()
        for x in range(width):
            for y in range(height):
                if pixels[x,y] in recolour_map.keys():
                    src.putpixel((x, y), recolour_map[pixels[x,y]])
        src.save(new_path)

def recreate_blank_image():
    touch_spots = [(228, 134)]
    if os.path.exists(BLANK_PATH):
        os.remove(BLANK_PATH)
    with Image.open(ORIGINAL_PATH) as img:
        img = img.rotate(270, Image.NEAREST, expand=1)
        (width, height) = img.size
        pixels = img.load()
        for x in range(width):
            for y in range(height):
                if pixels[x,y] == COLOURS['Original off black']:
                    img.putpixel((x, y), COLOURS['Full Black'])
        for (x,y) in touch_spots:
            img.putpixel((x, y), COLOURS['Full Black'])
        img.save(BLANK_PATH)

def generate_list_of_contiguous_areas(verbose=False):
    contiguities = {} # 'size' -> [one pixel on the interior of each contiguity of this size]
    contiguity_colour = COLOURS['Full White']
    redact_colour = COLOURS['Full Black']
    with Image.open(BLANK_PATH) as img:
        (width, height) = img.size
        pixels = img.load()
        for x in range(width):
            for y in range(height):
                if x == 218 and y == 123:
                    print(pixels[x,y])
                if pixels[x,y] == contiguity_colour:
                    # Seek outwards from this.
                    if verbose:
                        print(f'START SEARCHING A NEW CONTIGUITY AREA FROM ({x}, {y})')
                    pixels_in_contiguity = [(x,y)]
                    pixels_to_search_around = [(x,y)]
                    img.putpixel((x, y), redact_colour)
                    while pixels_to_search_around != []:
                        (search_x, search_y) = pixels_to_search_around.pop()
                        for (condition, new_x, new_y) in [
                            (search_x > 0, search_x-1, search_y),
                            (search_x < width-1, search_x+1, search_y),
                            (search_y > 0, search_x, search_y-1),
                            (search_y < height-1, search_x, search_y+1),
                        ]:
                            if condition and pixels[new_x, new_y] == contiguity_colour:
                                pixels_in_contiguity += [(new_x, new_y)]
                                pixels_to_search_around += [(new_x, new_y)]
                                img.putpixel((new_x, new_y), redact_colour)
                    contiguities[len(pixels_in_contiguity)] = contiguities.get(len(pixels_in_contiguity), []) + [(x,y)]
    return {k: v for k, v in sorted(contiguities.items(), reverse=True)}

# This just saves a few seconds from the start of each image generation.
def recreate_contiguities_map_file(verbose=False):
    CONTIGUITIES_FILE = './contiguities.py'
    contiguities = generate_list_of_contiguous_areas(verbose=verbose)
    if os.path.exists(CONTIGUITIES_FILE):
        os.remove(CONTIGUITIES_FILE)
    with open(CONTIGUITIES_FILE, 'w') as f:
        f.write('CONTIGUITIES = {\n')
        for k, vs in contiguities.items():  
            if len(vs) == 1:
                f.write(f'    {k}: {vs},\n')
            else:
                f.write(f'    {k}: [\n')
                for v in vs:
                    f.write(f'        {v},\n')
                f.write(f'    ],\n')
        f.write('}\n')

################################################################################
############# The actual "generate each coral per palette" function ############
################################################################################

def colour_in_blank_image_with_palette(new_image_path, desired_ratios, verbose=False):
    if os.path.exists(new_image_path):
        os.remove(new_image_path)
    contiguity_colour = COLOURS['Full White']
    total_pixels = sum([k*len(v) for k, v in CONTIGUITIES.items()])
    desired_percentages = totalise_percentage_meta_ratios(desired_ratios)
    desired_pixelage = {k: floor(total_pixels*v/100) for k, v in desired_percentages.items()}
    while sum(desired_pixelage.values()) < total_pixels:
        for k in desired_pixelage.keys():
            if sum(desired_pixelage.values()) < total_pixels:
                desired_pixelage[k] += 1
    print(f'Total pixels {total_pixels} ({sum(desired_pixelage.values())}?), split over {desired_pixelage}')
    with Image.open(BLANK_PATH) as img:
        (width, height) = img.size
        pixels = img.load()
        while CONTIGUITIES != {}:
            del_sizes = []
            for size, zones in CONTIGUITIES.items():
                for colour in desired_pixelage.keys():
                    if desired_pixelage[colour] >= size and len(zones) > 0:
                        # colour in one of the zones
                        (zone_x, zone_y) = zones.pop()
                        print(f'FILLING IN AREA {size} @ ({zone_x}, {zone_y}), with {colour}, only {desired_pixelage[colour]-size} left to fill with {colour}')
                        pixels_to_search_around = [(zone_x, zone_y)]
                        img.putpixel((zone_x, zone_y), colour)
                        while pixels_to_search_around != []:
                            (search_x, search_y) = pixels_to_search_around.pop()
                            for (condition, new_x, new_y) in [
                                (search_x > 0, search_x-1, search_y),
                                (search_x < width-1, search_x+1, search_y),
                                (search_y > 0, search_x, search_y-1),
                                (search_y < height-1, search_x, search_y+1),
                            ]:
                                if condition and pixels[new_x, new_y] == contiguity_colour:
                                    pixels_to_search_around += [(new_x, new_y)]
                                    img.putpixel((new_x, new_y), colour)
                        desired_pixelage[colour] -= size
                        total_pixels -= size
                # We want to sort the colours by how many pixels are left to
                # colour in each iteration, but not before the first iteration,
                # so we put it here after looping through it
                desired_pixelage = {k: v for k, v in sorted(desired_pixelage.items(), key=lambda item: item[1], reverse=True)}
                if zones == []:
                    del_sizes += [size]
            for size in del_sizes:
                del(CONTIGUITIES[size])
        img.save(new_image_path)

################################################################################
# Space where stuff gets run idk lol.
################################################################################

## How to initialise / recreate the files.
# recreate_blank_image()
# recreate_contiguities_map_file()

## Example run of `colour_in_blank_image_with_palette`
# colour_in_blank_image_with_palette('_javascript.png', PALETTES['JavaScript'], verbose=True)

for lang in ['C_Sharp', 'Go', 'Java', 'JavaScript', 'Julia', 'LaTeX', 'Python', 'R', 'Ruby', 'Rust']:
    if lang in PALETTES.keys():
        print(f'CREATING {lang}')
        colour_in_blank_image_with_palette(f'_{lang}.png', PALETTES[lang], verbose=True)
