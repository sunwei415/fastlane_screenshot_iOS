#!/usr/bin/env python
# -*- coding: utf-8 -*-
import calendar
import codecs
import os
import subprocess
import time


def get_path_for_versions_h():
    KEY_SRCROOT = 'SRCROOT'
    src_root = os.environ[KEY_SRCROOT] if KEY_SRCROOT in os.environ else os.getcwd()
    versions_folder = os.path.join(src_root, 'Versions')
    versions_file = os.path.join(versions_folder, 'versions.h')
    if not os.path.isdir(versions_folder):
        os.mkdir(versions_folder)

    return versions_file


def test_git_hash_to_versions():

    xcode_configuration = os.environ['CONFIGURATION']
    print(xcode_configuration)

    versions_file = get_path_for_versions_h()

    versions_h_exists = os.path.isfile(versions_file)

    define_gf_bundle_version = '#define GFBundleVersion'

    versions_file_is_legal = False

    is_one_minute_ago = True

    if versions_h_exists:
        versions_h_content = codecs.open(versions_file, encoding='utf8').read()
        versions_file_is_legal = define_gf_bundle_version in versions_h_content
        last_modified = os.path.getmtime(versions_file)
        current_timestamp = time.time()
        is_one_minute_ago = current_timestamp - last_modified > 60

    is_archiving = os.environ['ACTION'] == 'install'

    should_generate_versions_h = (is_archiving and is_one_minute_ago) or (xcode_configuration == 'Debug') or (not versions_file_is_legal)
    if not should_generate_versions_h:
        return

    TW_BUNDLE_SHORT_VERSION_DATE = "October 1 2018 00:00:00 GMT"

    epoch_2018_8_1 = calendar.timegm(time.strptime(TW_BUNDLE_SHORT_VERSION_DATE, '%B %d %Y %H:%M:%S GMT'))
    epoch_now = calendar.timegm(time.gmtime())

    minutes_since_date = (epoch_now - epoch_2018_8_1) / 60

    print(minutes_since_date)

    get_git_hash = "git rev-parse --short=7 HEAD"

    git_hash = subprocess.check_output(get_git_hash.split(' ')).strip()

    # We must prefix the git hash with a 1
    # If it starts with a zero, when we decimalize it,
    # and later hexify it, we'll lose the zero.
    one_prefixed_git_hash = "1" + git_hash

    decimal = int(one_prefixed_git_hash, 16)

    TW_BUNDLE_VERSION = '%d.%d' % (minutes_since_date, decimal)

    print(TW_BUNDLE_VERSION)

    codecs.open(versions_file, 'w', encoding='utf8').write(
        '%s %s' % (define_gf_bundle_version, TW_BUNDLE_VERSION))


if __name__ == '__main__':
    test_git_hash_to_versions()
