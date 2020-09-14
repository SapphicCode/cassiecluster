#!/usr/bin/env python3

import shutil
import os
import pathlib
import tempfile

from .crypt import decrypt, vault_regex


def command(args):
    if args.file:
        return decrypt_file(args.file)
    return decrypt_path(args.path)


def decrypt_path(path: pathlib.Path):
    for root, _, files in os.walk(path):
        for file in files:
            path = pathlib.Path(root, file)
            decrypt_file(path)


def decrypt_file(path: pathlib.Path):
    with path.open('r') as f:
        original = f.read()
        newdata = original

    for match in vault_regex.finditer(newdata):
        secret = decrypt(match.group())
        newdata = newdata.replace(match.group(), secret, 1)

    if newdata != original:
        with tempfile.TemporaryFile() as tmp:
            newpath = path if path.suffix != '.crypt' else path.with_suffix('')
            shutil.copystat(path, tmp.name)
            with newpath.open('w') as f:
                f.write(newdata)
            shutil.copystat(tmp.name, newpath)
            print(newpath)
