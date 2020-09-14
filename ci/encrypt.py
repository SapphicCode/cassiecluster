import shutil

from .crypt import encrypt


def command(args):
    with args.file.open('r') as f:
        ciphertext = encrypt(f.read())
    newfile = args.file.with_suffix(args.file.suffix + '.crypt')
    with newfile.open('w') as f:
        f.write(ciphertext)
    print(newfile)
    shutil.copystat(args.file, newfile)

    if args.rm:
        args.file.unlink()
        print('rm:', args.file)
