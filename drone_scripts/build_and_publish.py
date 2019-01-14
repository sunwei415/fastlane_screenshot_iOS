#!/usr/bin/env python
# -*- coding: utf-8 -*-
import os

__author__ = "Sun Wei"
__copyright__ = "Copyright (C) 2018 GFLoan Co. LTD"
__license__ = "Private"
__version__ = "1.0"


def analyze_ipa_with_biplist(ipa_path):
    import zipfile

    from biplist import readPlist

    ipa_file = zipfile.ZipFile(ipa_path)
    plist_path = find_plist_path(ipa_file)
    plist_data = ipa_file.read(plist_path)

    from tempfile import mkstemp

    fd, path = mkstemp()
    open(path, "wb").write(plist_data)
    plist_root = readPlist(path)
    return print_ipa_info(plist_root)


def find_plist_path(zip_file):
    import re
    name_list = zip_file.namelist()
    pattern = re.compile(r'Payload/[^/]*.app/Info.plist')
    for path in name_list:
        m = pattern.match(path)
        if m is not None:
            return m.group()


def print_ipa_info(plist_root):
    print ('Bundle Identifier: %s' % plist_root['CFBundleIdentifier'])
    print ('Version: %s' % plist_root['CFBundleShortVersionString'])
    return plist_root['CFBundleVersion']


def test_xcode_drone():

    os.system("git stash && git clean -f -d -x")

    os.system('fastlane drone_online_beta')

    os.environ["USE_PREVIOUS_VERSIONS_H"] = "YES"
    os.system('fastlane drone_test_beta')


if __name__ == '__main__':
    test_xcode_drone()
