#! /usr/bin/env python
import argparse
import getpass
import os.path
import subprocess
import tarfile

REL_GNOME_EXTENSIONS_DIR = '/.local/share/gnome-shell/extensions/'
REL_FIREFOX_SETTINGS_DIR = '/.mozilla/'

GNOME_EXTENSIONS_DIR = os.path.expanduser('~') + REL_GNOME_EXTENSIONS_DIR
FIREFOX_SETTINGS_DIR = os.path.expanduser('~') + REL_FIREFOX_SETTINGS_DIR

DCONF_SETTINGS_FILENAME = os.path.expanduser('~') + '/dconf-extensions-settings.dump'
TAR_FILENAME = os.path.expanduser('~') + '/gnome_settings.tar.gz'


def export_settings():
    export_firefox_settings = input('>>>> Do you want to export firefox settings? The filesize will be WAY bigger. [y/N] ').lower()

    print('>>>> Starting to export settings...')
    dconf_settings = subprocess.run(['dconf', 'dump', '/'], capture_output=True, check=False).stdout
    clean_dconf_settings = dconf_settings.replace(getpass.getuser().encode('utf8'), b'%%USER%%')
    dconf_settings_dump = open(DCONF_SETTINGS_FILENAME, 'wb')
    dconf_settings_dump.write(clean_dconf_settings)

    with tarfile.open(TAR_FILENAME, "w:gz") as tar:
        print('>>>> Exporting extensions...')
        tar.add(GNOME_EXTENSIONS_DIR, arcname=REL_GNOME_EXTENSIONS_DIR)

        if export_firefox_settings == 'y':
            print('>>>> Exporting firefox settings...')
            tar.add(FIREFOX_SETTINGS_DIR, arcname=REL_FIREFOX_SETTINGS_DIR)

        print('>>>> Exporting dconfs...')
        tar.add(DCONF_SETTINGS_FILENAME, arcname='dconf-extensions-settings.dump')

    subprocess.run(['rm', DCONF_SETTINGS_FILENAME], check=False)
    print(f'>>>> Done! Check the tar created at {TAR_FILENAME}!')
    if export_firefox_settings == 'y':
        print('\n------------------------------ DISCLAIMER ------------------------------\n')
        print('>>>> Since you chose to export firefox settings, your tar file WILL contain personal and sensitive data.')
        print('>>>> DO NOT share it with anyone, and store it safely. :]')

def import_settings():
    print('>>>> Starting to import settings...')

    print('>>>> Unpacking static files...')
    subprocess.run(['tar', '-xzf', TAR_FILENAME, '-C', os.path.expanduser('~')], check=True)

    print('>>>> Importing dconfs...\n')
    dconf_settings = open(DCONF_SETTINGS_FILENAME, 'rb').read()
    subprocess.run(
        ['dconf', 'load', '-f', '/'],
        input=dconf_settings.replace(b'%%USER%%', getpass.getuser().encode('utf8')),
        check=False
    )

    subprocess.run(['rm', DCONF_SETTINGS_FILENAME], check=False)
    print('\n>>>> Done! You may need to restart your Gnome session for settings to load (logout and login).')

if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description='This is a simple script to export and \
            import all settings and extensions from and for a Gnome user.'
    )

    parser.add_argument(
        '--export-settings',
        action="store_true",
        help="Exports a tar file with all settings and extensions."
    )
    parser.add_argument(
        '--import-settings',
        action="store_true",
        help='''Imports all settings and extensions from a previously exported tar file.
        This file should be located at your user\'s home directory.'''
    )

    args = parser.parse_args()

    if args.export_settings:
        export_settings()
    elif args.import_settings:
        import_settings()

