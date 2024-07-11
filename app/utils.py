import os
import json
import logging
#import xml.etree.ElementTree as etree
from lxml import etree 

from PySide6.QtCore import QObject, Slot, QStringListModel



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


class SceneManager(QObject):
    def __init__(self, base_dir='scenes'):
        super().__init__()
        self.base_dir = base_dir
        self.scenes = self.load_scenes()

    def load_scenes(self):
        scenes = {}
        for beam in os.listdir(self.base_dir):
            beam_path = os.path.join(self.base_dir, beam)
            if os.path.isdir(beam_path):
                scenes[beam] = {}
                for group in os.listdir(beam_path):
                    group_path = os.path.join(beam_path, group)
                    if os.path.isdir(group_path):
                        scenes[beam][group] = {}
                        for scene_file in os.listdir(group_path):
                            if scene_file.endswith('.json'):
                                scene_path = os.path.join(group_path, scene_file)
                                with open(scene_path, 'r') as file:
                                    scene_data = json.load(file)
                                    scene_name = os.path.splitext(scene_file)[0]
                                    scenes[beam][group][scene_name] = scene_data
        return scenes

    @Slot(str, str, result='QVariantList')
    def list_scenes_for_beam_and_group(self, beam, group):
        if beam in self.scenes and group in self.scenes[beam]:
            return list(self.scenes[beam][group].keys())
        return []

from PySide6.QtCore import QObject, Slot

class SceneManager(QObject):
    def __init__(self, base_dir='scenes'):
        super().__init__()
        self.base_dir = base_dir
        self.scenes = self.load_scenes()

    def load_scenes(self):
        scenes = {}
        for beam in os.listdir(self.base_dir):
            beam_path = os.path.join(self.base_dir, beam)
            if os.path.isdir(beam_path):
                scenes[beam] = {}
                for group in os.listdir(beam_path):
                    group_path = os.path.join(beam_path, group)
                    if os.path.isdir(group_path):
                        scenes[beam][group] = {}
                        for scene_file in os.listdir(group_path):
                            if scene_file.endswith('.json'):
                                scene_path = os.path.join(group_path, scene_file)
                                with open(scene_path, 'r') as file:
                                    scene_data = json.load(file)
                                    scene_name = os.path.splitext(scene_file)[0]
                                    scenes[beam][group][scene_name] = scene_data
        return scenes

    @Slot(str, str, result=list)
    def list_scenes_for_beam_and_group(self, beam, group):
        if beam in self.scenes and group in self.scenes[beam]:
            return list(self.scenes[beam][group].keys())
        return []

    @Slot(list, result='QVariant')
    def find_matching_scene(self, dmx_values):
        for beam in self.scenes:
            for group in self.scenes[beam]:
                for scene_name, scene_data in self.scenes[beam][group].items():
                    if scene_data == dmx_values:
                        return {'beam': beam, 'group': group, 'scene': scene_name}
        return None

    @Slot(str, str, str, result='QVariant')
    def get_scene_data(self, beam, group, scene_name):
        return self.scenes.get(beam, {}).get(group, {}).get(scene_name, None)
