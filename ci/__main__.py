import argparse
import pathlib

from .encrypt import command as encrypt_command
from .decrypt import command as decrypt_command

if __name__ == '__main__':
    parser = argparse.ArgumentParser(prog='citool')
    subcommands = parser.add_subparsers(title='subcommands', dest='command')

    encrypt = subcommands.add_parser(name='encrypt')
    encrypt.add_argument('file', type=pathlib.Path)
    encrypt.add_argument('--rm', default=False, action='store_true')

    decrypt = subcommands.add_parser(name='decrypt')
    decrypt.add_argument('-p', '--path', type=pathlib.Path, default='.')
    decrypt.add_argument('-f', '--file', type=pathlib.Path, default=None)

    args = parser.parse_args()
    # print(args)
    if args.command == 'encrypt':
        encrypt_command(args)
    if args.command == 'decrypt':
        decrypt_command(args)
