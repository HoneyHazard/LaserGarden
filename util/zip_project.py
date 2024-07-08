#!/usr/bin/python3

import os
import zipfile

# List of items to include in the zip file
items_to_zip = [
    "app",
    "qlcplus_gruolin_olaalite_a001_a002",
    "qlcplus_workspace",
    "README.md",
    "run.sh",
    "util"
]

# Name of the output zip file
zip_filename = "repo_contents.zip"

# Create a zip file
with zipfile.ZipFile(zip_filename, 'w') as zipf:
    for item in items_to_zip:
        if os.path.isdir(item):
            for root, dirs, files in os.walk(item):
                for file in files:
                    file_path = os.path.join(root, file)
                    arcname = os.path.relpath(file_path, os.path.join(item, '..'))
                    zipf.write(file_path, arcname)
        else:
            zipf.write(item)

print(f"Repository contents have been zipped into {zip_filename}")
