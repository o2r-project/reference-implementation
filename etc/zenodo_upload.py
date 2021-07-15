#!/bin/env python2

"""
Copyright (c) 2018 o2r project

Helper functions to clear existing Zenodo deposit and upload files.
Creation of deposit, setting the version/metadata, and publishing the deposit are intentionally not included here.
"""

import os
import sys
import logging
import requests
import humanfriendly
from md5hash import scan

# (you must install the required Python modules before the first run: `pip install clint requests_toolbelt`)
#from clint.textui.progress import Bar
#from requests_toolbelt import MultipartEncoder, MultipartEncoderMonitor

logging.basicConfig(level=logging.INFO) # logging for requests

token = os.getenv('ZENODO_ACCESS_TOKEN')
deposit = os.getenv('ZENODO_DEPOSIT_ID')
ZENODO_URL = 'https://zenodo.org/api/deposit/depositions'

def upload_file(file, deposit_id):
    print('Uploading %s' % (file))
    file_name = os.path.basename(file)

    # streaming upload, https://toolbelt.readthedocs.io/en/latest/uploading-data.html#streaming-multipart-data-encoder
    #encoder = MultipartEncoder({
    #    'filename': file_name,
    #    'file': open(file, 'rb')
    #    })
    #bar = Bar(expected_size = encoder.len, filled_char = '=')
    #def callback(monitor):
    #    bar.show(monitor.bytes_read)
    #monitor = MultipartEncoderMonitor(encoder, callback)
    #print(monitor.content_type)
    #    r = requests.post('%s/%s/files?access_token=%s' % (ZENODO_URL, deposit_id, token),
    #    data = m,
    #    headers = {'Content-Type': m.content_type})

    r = requests.post('%s/%s/files?access_token=%s' % (ZENODO_URL, deposit_id, token),
        data = {'filename': file_name},
        files = {'file': open(file, 'rb')})
    if r.status_code != 201:
        print('Error uploading file: %s' % (r.text))
        sys.exit()
    else:
        print('Uploaded file (HTTP %s): %s' % (r.status_code, r.json()['links']['self']))
        return r.json()['links']['self']

def clear_files(deposit_id):
    print('Clearing files from deposit %s ...' % (deposit_id))
    r = requests.get('%s/%s' % (ZENODO_URL, deposit_id), params = {'access_token': token})
    if r.status_code != 200:
        print('Error getting list of files: %s' % (r.text))
        sys.exit()
    else:
        for file in r.json()['files']:
            print('Deleting %s | %s' % (file['id'], file['links']['download']))
            r_delete = requests.delete('%s/%s/files/%s' % (ZENODO_URL, deposit_id, file['id']), params = {'access_token': token})
            if r_delete.status_code != 204:
                print('Error deleting existing file (HTTP %s): %s', (r_delete.text, r_delete.status_code))
                sys.exit()
            else:
                print('Deleted %s' % (file['id']))

def new_version(deposit_id):
    print('Creating new version for %s' % (deposit_id))
    r = requests.post('%s/%s/actions/newversion' % (ZENODO_URL, deposit_id), params = {'access_token': token})
    if r.status_code != 201:
        print('Error creating new version: %s' % (r.text))
        sys.exit()
    else:
        print('Created new version %s' % (r.json()['links']['latest_draft']))
        return os.path.basename(r.json()['links']['latest_draft'])


if __name__ == '__main__':
    #deposit = new_version(deposit)
    clear_files(deposit)

    files = ['README.md',
        'README-WIN.md',
        'Makefile',
        'erc-spec.pdf',
        'o2r-architecture.pdf',
        'o2r-openapi.pdf',
        'o2r-reference-implementation-files.zip',
        'o2r-reference-implementation-modules.zip',
        'versions.txt'
        ]
    for file in files:
        upload_file(file, deposit)

    print('Uploaded small files to %s/%s: %s' % (ZENODO_URL, deposit, str(files)))
    input('Go to https://zenodo.org/deposit/%s and upload the files >100MB: \n\n%s\n\n. Done?' % (deposit, ['o2r-reference-implementation-images.tar.gz', 'o2r-docs.zip']))
    print('Deposition files:')
    r = requests.get('%s/%s' % (ZENODO_URL, deposit), params = {'access_token': token})
    for file in r.json()['files']:
            print('    %s (%s) | %s (remote) | %s (local)' % (file['filename'], humanfriendly.format_size(file['filesize']), file['checksum'], scan(file['filename'])))
    
    #publish_deposit(deposit)
    #print('Published new deposit at: %s/%s' % (ZENODO_URL, deposit))
