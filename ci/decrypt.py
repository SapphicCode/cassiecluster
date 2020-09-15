#!/usr/bin/env python3

import shutil
import os
import pathlib

from .crypt import decrypt, vault_regex


def command(args):
    if args.file:
        return decrypt_file(args.file)
    return decrypt_path(args.path)


def decrypt_path(path: pathlib.Path):
    for root, _, files in os.walk(path):
        for file in (x for x in files if x.endswith('.crypt')):
            path = pathlib.Path(root, file)
            decrypt_file(path)


def decrypt_file(path: pathlib.Path):
    try:
        with path.open('r') as f:
            original = f.read()
            newdata = original
    except UnicodeDecodeError:
        return  # not a config file, clearly

    for match in vault_regex.finditer(newdata):
        secret = decrypt(match.group())
        newdata = newdata.replace(match.group(), secret, 1)

    if newdata != original:
        newpath = path.with_suffix('')
        with newpath.open('w') as f:
            f.write(newdata)
        shutil.copystat(path, newpath)
        print(newpath)
