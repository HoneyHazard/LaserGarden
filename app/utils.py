import os
import json
import logging
import xml.etree.ElementTree as ET

def change_to_parent_dir_if_in_main():
    if os.path.basename(os.getcwd()) == 'main':
        os.chdir('..')


def parse_qlc_workspace(file_path):
    """Parse QLC workspace file and import scenes."""
    scenes = {}
    if not os.path.isfile(file_path):
        logging.error(f"QLC workspace file {file_path} not found.")
        return scenes

    tree = ET.parse(file_path)
    root = tree.getroot()

    for function in root.findall(".//Function[@Type='Scene']"):
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
            values = fixture_val.text.strip().split(',')
            scene_data = []

            for i in range(0, len(values), 2):
                scene_data.append({
                    "channel": int(values[i]),
                    "value": int(values[i + 1])
                })

            # Ensure directory structure exists
            if group:
                dir_path = os.path.join('scenes', beam, group)
            else:
                dir_path = os.path.join('scenes', beam)
            os.makedirs(dir_path, exist_ok=True)

            # Save scene as JSON file
            scene_file_path = os.path.join(dir_path, f"{pattern}.json")
            with open(scene_file_path, 'w') as scene_file:
                json.dump(scene_data, scene_file, indent=4)

            scenes[name] = scene_file_path

    logging.info(f"Found and imported {len(scenes)} scenes from the QLC workspace file.")
    return scenes
