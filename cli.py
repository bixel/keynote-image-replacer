#! /usr/bin/env python3

from jinja2 import Environment
import argparse
import os
import glob
import fnmatch
import pprint


DEBUG = False


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('path', nargs='+', type=str)
    parser.add_argument('--slides', nargs='+', type=str)
    parser.add_argument('--images', nargs='+', type=str)
    parser.add_argument('--mode', type=str, default='template')
    parser.add_argument('--debug', action='store_true', default=False)
    args = parser.parse_args()
    if args.debug:
        global DEBUG
        DEBUG = True
    return args


def debug(obj):
    global DEBUG
    if DEBUG:
        pprint.pprint(obj)


if __name__ == '__main__':
    args = parse_args()

    jenv = Environment(
        block_start_string='[%',
        block_end_string='%]',
        variable_start_string='[[',
        variable_end_string=']]',
    )

    with open(f'{args.mode}.applescript') as f:
        template = jenv.from_string(f.read())

    files = []
    for path in args.path:
        files += glob.glob(os.path.expanduser(path))
    debug(files)

    slides = []
    for slideexp in args.slides:
        slide_candidates = fnmatch.filter(files, slideexp)
        debug(slide_candidates)
        images = []
        for imageexp in args.images:
            image_candidates = fnmatch.filter(slide_candidates, imageexp)
            if len(image_candidates) != 1:
                if len(image_candidates) == 0:
                    errormsg = (f'Expression {imageexp} did not match any file'
                        f' for slide expression {slideexp}')
                else:
                    errormsg = (f'Expression {imageexp} did match more than one'
                        f' file for slide expression {slideexp}:\n{image_candidates}')
                raise ValueError(errormsg)
            images.append(image_candidates[0])
        slides.append(images)

    rendered = template.render(slides=slides)
    print(rendered)
