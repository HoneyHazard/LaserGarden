import os
import json
import logging
#import xml.etree.ElementTree as etree
from lxml import etree 

def change_to_parent_dir_if_in_main():
    if os.path.basename(os.getcwd()) == 'main':
        os.chdir('..')

def remove_namespace(tree):
    for elem in tree.getiterator():
        if elem.tag.startswith('{'):
            elem.tag = elem.tag.split('}', 1)[1]  # Strip namespace
        for key in list(elem.attrib):
            if key.startswith('{'):
                new_key = key.split('}', 1)[1]
                elem.attrib[new_key] = elem.attrib.pop(key)

def parse_qlc_workspace(file_path):
    """Parse QLC workspace file and import scenes."""
    scenes = {}
    if not os.path.isfile(file_path):
        logging.error(f"QLC workspace file {file_path} not found.")
        return scenes

    tree = etree.parse(file_path)
    root = tree.getroot()

    remove_namespace(root)

    logging.info(f"root = {root}")

    for function in root.findall(".//Function[@Type='Scene']"):
        #logging.info(f"Processing: {function}")
        name = function.attrib['Name']
        parts = name.split('_', 2)

        if len(parts) < 3:
            # Handle non-compliant scenes
            if len(parts) == 2:  # Scenes like a_reset
                beam, pattern = parts
                group = 'other'
            else:
                beam = 'other'
                group = ''
                pattern = name
        else:
            beam, group, pattern = parts

        fixture_val = function.find('FixtureVal')
        if fixture_val is not None:
            data_to_save = []
            values = fixture_val.text.strip().split(',')
            for val in values:
                data_to_save.append(int(val))  

            # Ensure directory structure exists
            if group:
                dir_path = os.path.join('scenes', beam, group)
            else:
                dir_path = os.path.join('scenes', beam)
            os.makedirs(dir_path, exist_ok=True)

            # Save scene as JSON file
            scene_file_path = os.path.join(dir_path, f"{pattern}.json")
            with open(scene_file_path, 'w') as scene_file:
                json.dump(data_to_save, scene_file)
            
            scenes[name] = scene_file_path 

            logging.info(f"Imported scene '{name}' to '{scene_file_path}")

    logging.info(f"Found and imported {len(scenes)} scenes from the QLC workspace file.")
    return scenes
